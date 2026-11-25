"""Unit tests validating the benchmark suite generator and runner logic."""

from __future__ import annotations

import csv
import json
from pathlib import Path
from unittest.mock import MagicMock

from benchmark.generate_suite import (
    build_manifest,
    generate_cases,
    generate_seed_sql,
    table_specs,
)
from benchmark.runner.benchmark_runner import (
    compare_rows,
    execute_sql,
    extract_cte_names,
    has_hallucinated_table,
    manifest_names,
    table_recall,
    wrong_tables,
)

ROOT = Path(__file__).resolve().parents[1] / "benchmark"


class TestBenchmarkGeneratorFixes:

    def test_seed_data_fixes_hierarchies_nulls_and_segments(self) -> None:
        seed_sql = generate_seed_sql(table_specs())

        # Categories & employees form real trees (row 2 -> parent 1, row 3 -> parent 2; no self-loops)
        assert "(NULL, 'Categories 1', 'cat-1')" in seed_sql
        assert "(1, 'Categories 2', 'cat-2')" in seed_sql
        assert "(2, 'Categories 3', 'cat-3')" in seed_sql

        # VIP segment exists to match TC015 / TC139
        assert "('VIP', 'Seeded customer_segments row 1')" in seed_sql

        # NULL branches actually exist for customers (segment_id, last_name, birth_date) and addresses (line2)
        assert "NULL, 1, 'customers4@example.com'" in seed_sql
        assert "'First11', NULL," in seed_sql
        assert "NULL, 'Austin'" in seed_sql

        # Mix of alphabetic-only and alphanumeric product names for REGEXP '[0-9]' (TC137)
        assert "'Classic Canvas Tote'" in seed_sql
        assert "'Studio Monitor 27'" in seed_sql

    def test_generated_cases_and_manifest_consistent(self) -> None:
        specs = table_specs()
        manifest = build_manifest(specs)
        assert manifest["table_count"] == 100

        cases = generate_cases()
        assert len(cases) == 147
        by_id = {c["test_id"]: c for c in cases}

        assert "s.name = 'VIP'" in by_id["TC015"]["expected_sql"]
        assert "CURDATE()" in by_id["TC032"]["expected_sql"]
        assert "CURDATE()" in by_id["TC139"]["expected_sql"]
        assert "2026-07-24" in by_id["TC129"]["human_query"]

        # Regenerated CSV on disk matches generator output
        with (ROOT / "testcases" / "test_cases.csv").open(newline="", encoding="utf-8") as fh:
            disk_cases = list(csv.DictReader(fh))
        assert len(disk_cases) == len(cases)


class TestBenchmarkRunnerFixes:

    def test_cte_names_not_flagged_as_hallucinated_tables(self) -> None:
        valid_tables, _ = manifest_names(ROOT / "schema" / "schema_manifest.json")

        cte_sql = (
            "WITH customer_revenue AS (SELECT customer_id, SUM(total_amount) AS rev FROM orders GROUP BY customer_id) "
            "SELECT c.email, cr.rev FROM customer_revenue cr JOIN customers c ON c.id = cr.customer_id;"
        )
        assert extract_cte_names(cte_sql) == {"customer_revenue"}
        assert has_hallucinated_table(cte_sql, valid_tables) is False

        multi_cte_sql = (
            "WITH monthly AS (SELECT id FROM orders), ranked AS (SELECT id FROM monthly) "
            "SELECT * FROM ranked;"
        )
        assert extract_cte_names(multi_cte_sql) == {"monthly", "ranked"}
        assert has_hallucinated_table(multi_cte_sql, valid_tables) is False

        bad_sql = "SELECT * FROM nonexistent_ghost_table;"
        assert has_hallucinated_table(bad_sql, valid_tables) is True

    def test_wrong_tables_checks_full_coverage_including_views(self) -> None:
        join_case = {"tables_involved": "customers,orders"}
        # Missing 'orders' should be flagged as wrong_tables=True and recall=0.5
        assert table_recall(join_case, ["customers"]) == 0.5
        assert wrong_tables(join_case, ["customers"], "SELECT * FROM customers;") is True
        assert wrong_tables(join_case, ["customers", "orders"], "SELECT * FROM customers c JOIN orders o ON o.customer_id = c.id;") is False

        # Views should NOT be ignored
        view_case = {"tables_involved": "v_customer_lifetime_value"}
        assert table_recall(view_case, ["orders"]) == 0.0
        assert wrong_tables(view_case, ["orders"], "SELECT * FROM orders;") is True
        assert wrong_tables(view_case, ["v_customer_lifetime_value"], "SELECT * FROM v_customer_lifetime_value;") is False

    def test_compare_rows_lenient_vs_strict_column_order(self) -> None:
        case = {"result_type": "multi_row", "order_sensitive": "true"}
        expected = {"rows": [[1, "SKU-1", 10.0], [2, "SKU-2", 20.0]]}
        permuted = [["SKU-1", 1, 10.0], ["SKU-2", 2, 20.0]]

        outcome_lenient, _ = compare_rows(case, expected, permuted, strict=False)
        assert outcome_lenient == "PASS"

        outcome_strict, _ = compare_rows(case, expected, permuted, strict=True)
        assert outcome_strict == "FAIL_CONTENT_MISMATCH"

    def test_execute_sql_allows_leading_comments_and_blocks_mutations(self) -> None:
        conn = MagicMock()
        cursor = MagicMock()
        cursor.description = [("id",)]
        cursor.fetchall.return_value = [(1,)]
        conn.cursor.return_value = cursor

        cols, rows, _ = execute_sql(conn, "-- leading comment\nSELECT id FROM orders;", timeout_seconds=5)
        assert cols == ["id"]
        assert rows == [[1]]

        import pytest

        with pytest.raises(ValueError, match="mutating"):
            execute_sql(conn, "/* tricky */ DELETE FROM orders;", timeout_seconds=5)

        with pytest.raises(ValueError, match="multi-statement"):
            execute_sql(conn, "SELECT 1; DROP TABLE orders;", timeout_seconds=5)
