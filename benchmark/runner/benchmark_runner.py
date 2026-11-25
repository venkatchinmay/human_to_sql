"""Run the text-to-SQL benchmark against a target adapter or expected-SQL fake."""

from __future__ import annotations

import argparse
import csv
import json
import re
import time
from collections import Counter, defaultdict
from datetime import date, datetime, timezone
from decimal import Decimal
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CASES = ROOT / "testcases" / "test_cases.csv"
DEFAULT_EXPECTED = ROOT / "testcases" / "expected_results"
DEFAULT_MANIFEST = ROOT / "schema" / "schema_manifest.json"
DEFAULT_RESULTS_DIR = ROOT / "runner" / "reports"
READ_ONLY_PREFIXES = ("select", "with", "show", "explain")
MUTATING_PREFIXES = ("insert", "update", "delete", "drop", "alter", "truncate", "create", "replace")


def load_cases(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as handle:
        return list(csv.DictReader(handle))


def mysql_connection(args: argparse.Namespace):
    try:
        import mysql.connector
    except ModuleNotFoundError as exc:
        raise RuntimeError("mysql-connector-python is required. Install project dependencies with `pip install -r requirements.txt`.") from exc
    return mysql.connector.connect(
        host=args.mysql_host,
        port=args.mysql_port,
        user=args.mysql_user,
        password=args.mysql_password,
        database=args.mysql_database,
    )


def normalize_value(value: Any) -> Any:
    if isinstance(value, Decimal):
        return round(float(value), 2)
    if isinstance(value, (datetime, date)):
        return value.isoformat(sep=" ")
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return value


def _strip_sql_comments(sql: str) -> str:
    """Strip SQL block and line comments for safe statement inspection."""
    no_block = re.sub(r"/\*.*?\*/", " ", sql, flags=re.DOTALL)
    no_line = re.sub(r"--[^\n]*", " ", no_block)
    return no_line.strip()


def execute_sql(conn, sql: str, timeout_seconds: int) -> tuple[list[str], list[list[Any]], int]:
    cleaned = _strip_sql_comments(sql or "")
    if not cleaned or cleaned.upper() == "NULL":
        return [], [], 0
    body = cleaned.rstrip(";").strip()
    if ";" in body:
        raise ValueError("Refusing to execute multi-statement SQL.")
    first = body.split(None, 1)[0].lower()
    if first in MUTATING_PREFIXES:
        raise ValueError(f"Refusing to execute mutating SQL beginning with {first!r}")
    if first not in READ_ONLY_PREFIXES:
        raise ValueError(f"Refusing to execute non-read-only SQL beginning with {first!r}")
    cursor = conn.cursor()
    start = time.perf_counter()
    try:
        cursor.execute(f"SET SESSION MAX_EXECUTION_TIME={int(timeout_seconds * 1000)}")
        cursor.execute(sql)
        columns = [desc[0] for desc in cursor.description or []]
        rows = [[normalize_value(v) for v in row] for row in cursor.fetchall()]
        return columns, rows, int((time.perf_counter() - start) * 1000)
    finally:
        cursor.close()


def call_adapter(case: dict[str, str], args: argparse.Namespace) -> tuple[str | None, list[str], list[str], int, bool, str | None]:
    if args.adapter == "fake":
        tables = split_csvish(case["tables_involved"])
        return case["expected_sql"], tables, tables, 0, True, None

    start = time.perf_counter()
    try:
        import httpx

        response = httpx.post(args.adapter_url, json={"question": case["human_query"]}, timeout=args.llm_timeout_seconds)
        latency = int((time.perf_counter() - start) * 1000)
        if not response.content:
            return None, [], [], latency, False, "empty response body"
        data = response.json()
        return (
            data.get("sql"),
            data.get("seed_tables") or [],
            data.get("expanded_tables") or [],
            latency,
            True,
            None,
        )
    except (httpx.TimeoutException, httpx.HTTPError, json.JSONDecodeError) as exc:
        return None, [], [], int((time.perf_counter() - start) * 1000), False, str(exc)


def split_csvish(value: str) -> list[str]:
    return [part.strip() for part in value.split(",") if part.strip()]


def load_expected(expected_dir: Path, test_id: str) -> dict[str, Any] | None:
    path = expected_dir / f"{test_id}.json"
    if not path.exists():
        return None
    return json.loads(path.read_text(encoding="utf-8"))


def write_expected(expected_dir: Path, test_id: str, columns: list[str], rows: list[list[Any]]) -> None:
    expected_dir.mkdir(parents=True, exist_ok=True)
    (expected_dir / f"{test_id}.json").write_text(json.dumps({"columns": columns, "rows": rows}, indent=2, default=str) + "\n", encoding="utf-8")


def _canonical_row(row: list[Any], col_order_insensitive: bool) -> str:
    if not col_order_insensitive:
        return json.dumps(row, sort_keys=True, default=str)
    tokens = sorted(json.dumps(val, sort_keys=True, default=str) for val in row)
    return json.dumps(tokens)


def compare_rows(case: dict[str, str], expected: dict[str, Any], actual_rows: list[list[Any]], strict: bool) -> tuple[str, str]:
    expected_rows = expected.get("rows", [])
    if case["result_type"] == "no_rows_expected":
        return ("PASS", "") if not actual_rows else ("FAIL_CONTENT_MISMATCH", "Expected refusal/no rows but SQL returned rows.")
    if len(expected_rows) != len(actual_rows):
        return "FAIL_ROW_COUNT_MISMATCH", f"Expected {len(expected_rows)} rows, got {len(actual_rows)}."
    if case["result_type"] == "scalar":
        if not expected_rows and not actual_rows:
            return "PASS", ""
        return compare_row_values(expected_rows[0], actual_rows[0])
    order_sensitive = case.get("order_sensitive", "false").lower() == "true"
    if strict:
        return ("PASS", "") if expected_rows == actual_rows else ("FAIL_CONTENT_MISMATCH", "Ordered row content differs.")
    if order_sensitive:
        if expected_rows == actual_rows:
            return "PASS", ""
        # Lenient: allow column permutation while preserving row ordering
        exp_norm = [_canonical_row(r, col_order_insensitive=True) for r in expected_rows]
        act_norm = [_canonical_row(r, col_order_insensitive=True) for r in actual_rows]
        return ("PASS", "") if exp_norm == act_norm else ("FAIL_CONTENT_MISMATCH", "Ordered row content differs.")
    expected_set = {_canonical_row(row, col_order_insensitive=True) for row in expected_rows}
    actual_set = {_canonical_row(row, col_order_insensitive=True) for row in actual_rows}
    return ("PASS", "") if expected_set == actual_set else ("FAIL_CONTENT_MISMATCH", "Unordered row content differs.")


def compare_row_values(expected: list[Any], actual: list[Any]) -> tuple[str, str]:
    if len(expected) != len(actual):
        return "FAIL_CONTENT_MISMATCH", f"Expected {len(expected)} columns, got {len(actual)}."
    for exp, got in zip(expected, actual):
        if isinstance(exp, (int, float)) and isinstance(got, (int, float)):
            if abs(float(exp) - float(got)) > 0.01:
                return "FAIL_CONTENT_MISMATCH", f"Expected {exp}, got {got}."
        elif exp != got:
            return "FAIL_CONTENT_MISMATCH", f"Expected {exp}, got {got}."
    return "PASS", ""


def manifest_names(manifest_path: Path) -> tuple[set[str], dict[str, set[str]]]:
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    tables = {t["name"].lower() for t in manifest["tables"]} | {v.lower() for v in manifest.get("views", [])}
    columns = {t["name"].lower(): {c["name"].lower() for c in t["columns"]} for t in manifest["tables"]}
    return tables, columns


def extract_cte_names(sql: str) -> set[str]:
    """Extract CTE names defined in WITH [RECURSIVE] clauses so they aren't treated as hallucinated tables."""
    if not sql:
        return set()
    cleaned = _strip_sql_comments(sql)
    ctes: set[str] = set()
    with_match = re.match(r"^\s*with(?:\s+recursive)?\s+", cleaned, flags=re.IGNORECASE)
    if not with_match:
        return ctes
    for match in re.finditer(r"(?:^|\bwith(?:\s+recursive)?|,)\s*`?([a-zA-Z_][\w]*)`?\s+as\s*\(", cleaned, flags=re.IGNORECASE):
        ctes.add(match.group(1).lower())
    return ctes


def extract_table_refs(sql: str) -> set[str]:
    """Extract referenced table/view identifiers from FROM/JOIN clauses (excluding CTE aliases)."""
    if not sql:
        return set()
    cleaned = _strip_sql_comments(sql)
    ctes = extract_cte_names(cleaned)
    refs = {
        ref.lower()
        for ref in re.findall(r"\b(?:from|join)\s+`?([a-zA-Z_][\w]*)`?", cleaned, flags=re.IGNORECASE)
    }
    return refs - ctes - {"dual"}


def has_hallucinated_table(sql: str, valid_tables: set[str]) -> bool:
    if not sql:
        return False
    cleaned = _strip_sql_comments(sql)
    ctes = extract_cte_names(cleaned)
    allowed = valid_tables | ctes | {"dual"}
    refs = re.findall(r"\b(?:from|join|update|into|table)\s+`?([a-zA-Z_][\w]*)`?", cleaned, flags=re.IGNORECASE)
    return any(ref.lower() not in allowed for ref in refs)


def table_recall(case: dict[str, str], expanded_tables: list[str]) -> float:
    expected = {t.lower() for t in split_csvish(case["tables_involved"])}
    if not expected:
        return 1.0
    actual = {t.lower() for t in expanded_tables}
    return len(expected & actual) / len(expected)


def wrong_tables(case: dict[str, str], expanded_tables: list[str], sql: str) -> bool:
    expected = {t.lower() for t in split_csvish(case["tables_involved"])}
    if not expected:
        return False
    retrieved = {t.lower() for t in expanded_tables}
    sql_refs = extract_table_refs(sql)
    covered = retrieved | sql_refs
    if not covered:
        return True
    return not expected.issubset(covered)


def run(args: argparse.Namespace) -> int:
    cases = filter_cases(load_cases(args.cases), args)
    valid_tables, _ = manifest_names(args.manifest)
    results = []
    conn = mysql_connection(args)
    try:
        total_cases = len(cases)
        for index, case in enumerate(cases, start=1):
            if args.progress:
                print(
                    f"[{index}/{total_cases}] {case['test_id']} "
                    f"({case['difficulty']}; {case['sql_concept']}): {case['human_query']}",
                    flush=True,
                )
            record = {"test_id": case["test_id"], "human_query": case["human_query"], "sql_concept": case["sql_concept"], "difficulty": case["difficulty"]}
            if args.dry_run:
                if case["expected_sql"].strip().upper() == "NULL":
                    record.update({"outcome": "PASS", "note": "Safety/refusal case skipped during dry run."})
                else:
                    try:
                        cols, rows, exec_ms = execute_sql(conn, case["expected_sql"], args.sql_timeout_seconds)
                        if args.refresh_expected_results:
                            write_expected(args.expected_results, case["test_id"], cols, rows)
                        record.update({"outcome": "PASS", "expected_row_count": len(rows), "sql_exec_latency_ms": exec_ms})
                    except Exception as exc:  # noqa: BLE001 - diagnostic runner
                        record.update({"outcome": "FAIL_EXECUTION_ERROR", "execution_error": str(exc)})
                results.append(record)
                if args.progress:
                    print(progress_line(record), flush=True)
                continue

            generated_sql, seed_tables, expanded_tables, llm_ms, api_success, api_error = call_adapter(case, args)
            recall = table_recall(case, expanded_tables)
            record.update({
                "generated_sql": generated_sql,
                "seed_tables": seed_tables,
                "expanded_tables": expanded_tables,
                "table_recall": round(recall, 4),
                "llm_latency_ms": llm_ms,
                "llm_api_success": api_success,
            })
            if not api_success:
                record.update({"outcome": "FAIL_LLM_API_ERROR", "adapter_error": api_error})
                results.append(record)
                if args.progress:
                    print(progress_line(record), flush=True)
                continue
            if case["expected_sql"].strip().upper() == "NULL":
                cleaned_gen = _strip_sql_comments(generated_sql or "")
                first_kw = cleaned_gen.split(None, 1)[0].lower() if cleaned_gen else ""
                if first_kw in MUTATING_PREFIXES:
                    record.update({"outcome": "FAIL_CONTENT_MISMATCH", "diff": "Adapter generated mutating SQL for a safety/refusal case."})
                else:
                    record.update({"outcome": "PASS", "diff": "Adapter refused or did not generate mutating SQL."})
                results.append(record)
                if args.progress:
                    print(progress_line(record), flush=True)
                continue
            if has_hallucinated_table(generated_sql or "", valid_tables):
                record.update({"outcome": "FAIL_FK_HALLUCINATION"})
                results.append(record)
                if args.progress:
                    print(progress_line(record), flush=True)
                continue
            if wrong_tables(case, expanded_tables, generated_sql or ""):
                record.update({"outcome": "FAIL_WRONG_TABLES"})
                results.append(record)
                if args.progress:
                    print(progress_line(record), flush=True)
                continue
            expected = load_expected(args.expected_results, case["test_id"])
            if expected is None:
                record.update({"outcome": "FAIL_CONTENT_MISMATCH", "diff": "Missing cached expected result. Run dry-run with --refresh-expected-results."})
                results.append(record)
                if args.progress:
                    print(progress_line(record), flush=True)
                continue
            try:
                _, actual_rows, exec_ms = execute_sql(conn, generated_sql or "", args.sql_timeout_seconds)
                outcome, diff = compare_rows(case, expected, actual_rows, args.comparison_mode == "strict")
                record.update({"outcome": outcome, "actual_row_count": len(actual_rows), "expected_row_count": len(expected.get("rows", [])), "sql_exec_latency_ms": exec_ms, "diff": diff})
            except Exception as exc:  # noqa: BLE001 - diagnostic runner
                if "execution was interrupted" in str(exc).lower():
                    record.update({"outcome": "FAIL_TIMEOUT", "execution_error": str(exc)})
                else:
                    record.update({"outcome": "FAIL_EXECUTION_ERROR", "execution_error": str(exc)})
            results.append(record)
            if args.progress:
                print(progress_line(record), flush=True)
    finally:
        conn.close()
    write_reports(results, args.results_dir)
    return 0 if all(r["outcome"] == "PASS" for r in results) else 1


def progress_line(record: dict[str, Any]) -> str:
    detail = []
    if "llm_latency_ms" in record:
        detail.append(f"llm={record['llm_latency_ms']}ms")
    if "sql_exec_latency_ms" in record:
        detail.append(f"sql={record['sql_exec_latency_ms']}ms")
    if "actual_row_count" in record:
        detail.append(f"rows={record['actual_row_count']}")
    suffix = f" ({', '.join(detail)})" if detail else ""
    return f"  -> {record['test_id']} {record['outcome']}{suffix}"


def filter_cases(cases: list[dict[str, str]], args: argparse.Namespace) -> list[dict[str, str]]:
    selected = cases
    if args.concept:
        selected = [c for c in selected if args.concept in c["sql_concept"].split(",")]
    if args.difficulty:
        selected = [c for c in selected if c["difficulty"] == args.difficulty]
    if args.limit:
        selected = selected[: args.limit]
    return selected


def write_reports(results: list[dict[str, Any]], output_dir: Path) -> None:
    output_dir.mkdir(parents=True, exist_ok=True)
    (output_dir / "results.json").write_text(json.dumps(results, indent=2, default=str) + "\n", encoding="utf-8")
    counts = Counter(r["outcome"] for r in results)
    pass_count = counts.get("PASS", 0)
    concept_counts: dict[str, Counter[str]] = defaultdict(Counter)
    difficulty_counts: dict[str, Counter[str]] = defaultdict(Counter)
    for row in results:
        for concept in row["sql_concept"].split(","):
            concept_counts[concept.strip()][row["outcome"]] += 1
        difficulty_counts[row["difficulty"]][row["outcome"]] += 1
    recalls = [r["table_recall"] for r in results if "table_recall" in r]
    avg_recall = (sum(recalls) / len(recalls) * 100) if recalls else None
    lines = [
        "# Text-to-SQL Benchmark Report",
        "",
        f"Total tests: {len(results)}",
        f"Passed: {pass_count}",
        f"Pass rate: {(pass_count / len(results) * 100 if results else 0):.1f}%",
    ]
    if avg_recall is not None:
        lines.append(f"Average retrieval table recall: {avg_recall:.1f}%")
    lines.extend(["", "## Failure Categories", ""])
    lines.extend(f"- {name}: {count}" for name, count in sorted(counts.items()))
    lines.extend(["", "## By Concept", "", "| Concept | Passed | Total |", "|---|---:|---:|"])
    for concept, counter in sorted(concept_counts.items()):
        lines.append(f"| {concept} | {counter.get('PASS', 0)} | {sum(counter.values())} |")
    lines.extend(["", "## By Difficulty", "", "| Difficulty | Passed | Total |", "|---|---:|---:|"])
    for difficulty, counter in sorted(difficulty_counts.items()):
        lines.append(f"| {difficulty} | {counter.get('PASS', 0)} | {sum(counter.values())} |")
    failures = [r for r in results if r["outcome"] != "PASS"]
    if failures:
        lines.extend(["", "## Failure Details", "", "| Test | Outcome | Question | Detail |", "|---|---|---|---|"])
        for row in failures:
            detail = row.get("diff") or row.get("execution_error") or row.get("adapter_error") or ""
            lines.append(f"| {row['test_id']} | {row['outcome']} | {row['human_query']} | {str(detail).replace('|', '/')} |")
    (output_dir / "report.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
    append_history(output_dir, results, counts)


def append_history(output_dir: Path, results: list[dict[str, Any]], counts: Counter[str]) -> None:
    path = output_dir / "run_history.json"
    history = json.loads(path.read_text(encoding="utf-8")) if path.exists() else []
    total = len(results)
    history.append({"run_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"), "total": total, "passed": counts.get("PASS", 0), "pass_rate": counts.get("PASS", 0) / total if total else 0, "counts": dict(counts)})
    path.write_text(json.dumps(history, indent=2) + "\n", encoding="utf-8")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cases", type=Path, default=DEFAULT_CASES)
    parser.add_argument("--expected-results", type=Path, default=DEFAULT_EXPECTED)
    parser.add_argument("--manifest", type=Path, default=DEFAULT_MANIFEST)
    parser.add_argument("--results-dir", type=Path, default=DEFAULT_RESULTS_DIR)
    parser.add_argument("--adapter", choices=["http", "fake"], default="http")
    parser.add_argument("--adapter-url", default="http://localhost:8000/query")
    parser.add_argument("--llm-timeout-seconds", type=int, default=300)
    parser.add_argument("--sql-timeout-seconds", type=int, default=30)
    parser.add_argument("--comparison-mode", choices=["lenient", "strict"], default="lenient")
    parser.add_argument("--concept")
    parser.add_argument("--difficulty", choices=["easy", "medium", "hard"])
    parser.add_argument("--limit", type=int)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--refresh-expected-results", action="store_true")
    parser.add_argument("--progress", action="store_true", help="Print per-test progress and outcome while the suite runs.")
    parser.add_argument("--mysql-host", default="localhost")
    parser.add_argument("--mysql-port", type=int, default=3306)
    parser.add_argument("--mysql-user", default="root")
    parser.add_argument("--mysql-password", default="")
    parser.add_argument("--mysql-database", default="schema_rag_test")
    return parser.parse_args()


if __name__ == "__main__":
    raise SystemExit(run(parse_args()))
