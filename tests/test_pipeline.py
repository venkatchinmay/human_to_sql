"""End-to-end unit tests for introspection, upsert, SQL safety, FastAPI, and portal."""

from __future__ import annotations

from pathlib import Path
from unittest.mock import AsyncMock, MagicMock, patch

import pytest
from fastapi.testclient import TestClient

from schema_rag.db.mysql_client import fetch_fk_edges, fetch_tables
from schema_rag.llm.sql_generator import generate_sql, sanitize_read_only_sql
from schema_rag.qdrant_store.upsert import build_ddl, build_doc_text, upsert_tables
from schema_rag.retrieval.prompt_builder import build_sql_prompt


class TestMySQLIntrospection:

    def test_fetch_tables_captures_column_types_indexes_and_views(self) -> None:
        conn = MagicMock()
        cursor = MagicMock()
        conn.cursor.return_value = cursor

        cursor.fetchall.side_effect = [
            # _COLUMNS_SQL
            [
                {
                    "TABLE_NAME": "products",
                    "COLUMN_NAME": "id",
                    "DATA_TYPE": "bigint",
                    "COLUMN_TYPE": "bigint",
                    "COLUMN_KEY": "PRI",
                    "IS_NULLABLE": "NO",
                    "COLUMN_COMMENT": "Primary key",
                    "EXTRA": "auto_increment",
                },
                {
                    "TABLE_NAME": "products",
                    "COLUMN_NAME": "status",
                    "DATA_TYPE": "enum",
                    "COLUMN_TYPE": "enum('draft','active')",
                    "COLUMN_KEY": "",
                    "IS_NULLABLE": "NO",
                    "COLUMN_COMMENT": "",
                    "EXTRA": "",
                },
                {
                    "TABLE_NAME": "v_active_products",
                    "COLUMN_NAME": "id",
                    "DATA_TYPE": "bigint",
                    "COLUMN_TYPE": "bigint",
                    "COLUMN_KEY": "",
                    "IS_NULLABLE": "NO",
                    "COLUMN_COMMENT": "",
                    "EXTRA": "",
                },
            ],
            # _TABLES_SQL
            [
                {"TABLE_NAME": "products", "TABLE_TYPE": "BASE TABLE", "TABLE_COMMENT": "Catalog items"},
                {"TABLE_NAME": "v_active_products", "TABLE_TYPE": "VIEW", "TABLE_COMMENT": "VIEW"},
            ],
            # _INDEXES_SQL
            [
                {
                    "TABLE_NAME": "products",
                    "INDEX_NAME": "ft_products_name",
                    "NON_UNIQUE": 1,
                    "INDEX_TYPE": "FULLTEXT",
                    "COLUMN_NAME": "status",
                }
            ],
            # _VIEWS_SQL
            [
                {
                    "TABLE_NAME": "v_active_products",
                    "VIEW_DEFINITION": "select id from products where status = 'active'",
                }
            ],
        ]

        tables = fetch_tables(conn, database="shop")
        assert "products" in tables
        assert tables["products"]["comment"] == "Catalog items"
        assert tables["products"]["columns"][1]["type"] == "enum('draft','active')"
        assert tables["products"]["indexes"][0]["type"] == "FULLTEXT"
        assert tables["v_active_products"]["table_type"] == "VIEW"
        assert "products" in tables["v_active_products"]["view_definition"]
        cursor.close.assert_called_once()

    def test_fetch_fk_edges(self) -> None:
        conn = MagicMock()
        cursor = MagicMock()
        conn.cursor.return_value = cursor
        cursor.fetchall.return_value = [
            {
                "TABLE_NAME": "orders",
                "COLUMN_NAME": "customer_id",
                "REFERENCED_TABLE_NAME": "customers",
                "REFERENCED_COLUMN_NAME": "id",
            }
        ]
        fk_map = fetch_fk_edges(conn, database="shop")
        assert fk_map == {
            "orders": [{"column": "customer_id", "ref_table": "customers", "ref_column": "id"}]
        }
        cursor.close.assert_called_once()


class TestUpsertBuilders:

    def test_build_doc_and_ddl_with_comments_and_indexes(self) -> None:
        cols = [
            {"name": "id", "type": "bigint", "key": "PRI", "nullable": False, "comment": ""},
            {"name": "email", "type": "varchar(160)", "key": "UNI", "nullable": False, "comment": "Login email"},
        ]
        fks = [{"column": "segment_id", "ref_table": "segments", "ref_column": "id"}]
        indexes = [{"name": "uq_email", "unique": True, "type": "BTREE", "columns": ["email"]}]

        doc = build_doc_text("customers", cols, fks, comment="Registered users", indexes=indexes)
        ddl = build_ddl("customers", cols, fks, comment="Registered users", indexes=indexes)

        assert "description: Registered users" in doc
        assert "Login email" in doc
        assert "UNIQUE KEY uq_email (email)" in ddl
        assert "FOREIGN KEY (segment_id) REFERENCES segments(id)" in ddl

    def test_build_ddl_for_view(self) -> None:
        cols = [{"name": "customer_id", "type": "bigint"}]
        ddl = build_ddl(
            "v_customer_ltv",
            cols,
            [],
            table_type="VIEW",
            view_definition="select customer_id from orders",
        )
        assert "CREATE VIEW v_customer_ltv" in ddl
        assert "Definition: select customer_id from orders" in ddl

    def test_upsert_tables_batches_points(self) -> None:
        client = MagicMock()
        dense = MagicMock()
        dense.encode_doc.return_value = [0.1] * 384
        sparse = MagicMock()
        sparse.encode.return_value = {"indices": [1, 2], "values": [0.5, 0.7]}

        tables = {
            f"t_{i}": {"columns": [{"name": "id", "type": "int", "key": "PRI", "nullable": False}]}
            for i in range(5)
        }
        count = upsert_tables(
            client,
            tables,
            {},
            dense,
            sparse,
            batch_size=2,
            collection_name="custom_col",
        )
        assert count == 5
        assert client.upsert.call_count == 3
        assert client.upsert.call_args_list[0].kwargs["collection_name"] == "custom_col"


class TestSQLSafetyAndGenerator:

    def test_sanitize_allows_read_only_queries(self) -> None:
        sql = "```sql\nSELECT id, name FROM products WHERE price < 100;\n```"
        assert sanitize_read_only_sql(sql) == "SELECT id, name FROM products WHERE price < 100;"

        cte = "WITH totals AS (SELECT id, updated_at FROM orders) SELECT * FROM totals;"
        assert sanitize_read_only_sql(cte) == cte

    def test_sanitize_blocks_mutating_and_multistatement_sql(self) -> None:
        assert sanitize_read_only_sql("DELETE FROM orders WHERE status = 'cancelled';") == ""
        assert sanitize_read_only_sql("DROP TABLE customers;") == ""
        assert sanitize_read_only_sql("UPDATE products SET price = 0;") == ""
        assert sanitize_read_only_sql("SELECT 1; DROP TABLE users;") == ""
        assert sanitize_read_only_sql("NULL") == ""

    @patch("schema_rag.llm.sql_generator.httpx.post")
    def test_generate_sql_chat_and_empty_body_guard(self, mock_post: MagicMock) -> None:
        resp = MagicMock()
        resp.content = b'{"message": {"content": "```sql\\nSELECT 1;\\n```"}}'
        resp.json.return_value = {"message": {"content": "```sql\nSELECT 1;\n```"}}
        mock_post.return_value = resp

        out = generate_sql("prompt", model="gemma3:4b", ollama_url="http://ollama:11434")
        assert out == "SELECT 1;"
        assert mock_post.call_args.args[0] == "http://ollama:11434/api/chat"

        empty_resp = MagicMock()
        empty_resp.content = b""
        mock_post.return_value = empty_resp
        with pytest.raises(RuntimeError, match="Empty response body"):
            generate_sql("prompt", model="gemma2:2b", ollama_url="http://ollama:11434")

    def test_prompt_builder_includes_read_only_rules(self) -> None:
        prompt = build_sql_prompt("List products", "CREATE TABLE products (id INT);")
        assert "CREATE TABLE products (id INT);" in prompt
        assert "read-only" in prompt.lower()


class TestFastAPIAndPortal:

    def test_api_query_and_ingest(self, tmp_path: Path) -> None:
        import schema_rag.api.app as api_app

        mock_retriever = MagicMock()
        mock_retriever.retrieve.return_value = {
            "seed_tables": ["orders"],
            "expanded_tables": ["orders", "users"],
            "ddl_context": "CREATE TABLE orders (id INT);",
            "payloads": [],
        }
        mock_retriever._dense_enc = MagicMock()
        mock_retriever._sparse_enc = MagicMock()

        with (
            patch.object(api_app, "_retriever", mock_retriever),
            patch("schema_rag.api.app.generate_sql", return_value="SELECT * FROM orders;"),
        ):
            client = TestClient(api_app.app, raise_server_exceptions=False)
            assert client.get("/health").json() == {"status": "ok"}

            resp = client.post("/query", json={"question": "Show orders"})
            assert resp.status_code == 200
            assert resp.json() == {
                "sql": "SELECT * FROM orders;",
                "seed_tables": ["orders"],
                "expanded_tables": ["orders", "users"],
            }

            bad_resp = client.post("/query", json={"question": "   "})
            assert bad_resp.status_code == 400

    def test_api_ingest_uses_configured_collection(self, tmp_path: Path) -> None:
        import schema_rag.api.app as api_app

        mock_retriever = MagicMock()
        mock_retriever._dense_enc = MagicMock()
        mock_retriever._sparse_enc = MagicMock()

        mock_qdrant = MagicMock()
        mock_qdrant.count.return_value = MagicMock(count=2)

        graph_path = tmp_path / "nested" / "fk_graph.json"
        mock_conn = MagicMock()

        with (
            patch.object(api_app, "_retriever", mock_retriever),
            patch.object(api_app, "FK_GRAPH_PATH", graph_path),
            patch.object(api_app, "QDRANT_COLLECTION", "custom_schema"),
            patch("schema_rag.db.mysql_client.get_connection", return_value=mock_conn),
            patch("schema_rag.db.mysql_client.fetch_tables", return_value={"orders": {"columns": []}}),
            patch("schema_rag.db.mysql_client.fetch_fk_edges", return_value={}),
            patch("qdrant_client.QdrantClient", return_value=mock_qdrant),
            patch("schema_rag.qdrant_store.collection.recreate_collection"),
            patch("schema_rag.qdrant_store.upsert.upsert_tables", return_value=2),
        ):
            client = TestClient(api_app.app)
            resp = client.post("/ingest")
            assert resp.status_code == 200
            assert resp.json() == {"message": "Ingestion complete", "tables": 1, "points": 2}
            mock_qdrant.count.assert_called_once_with(collection_name="custom_schema")
            mock_retriever.reload_fk_graph.assert_called_once_with(graph_path)
            mock_conn.close.assert_called_once()

    def test_portal_escapes_html_and_proxies(self) -> None:
        import portal as portal_mod

        client = TestClient(portal_mod.app)
        home = client.get("/")
        assert home.status_code == 200
        assert "escapeHtml" in home.text

        mock_resp = MagicMock()
        mock_resp.status_code = 200
        mock_resp.json.return_value = {"sql": "SELECT 1;", "seed_tables": [], "expanded_tables": []}

        with patch("portal.httpx.AsyncClient") as mock_client_cls:
            mock_client = mock_client_cls.return_value.__aenter__.return_value
            mock_client.post = AsyncMock(return_value=mock_resp)
            res = client.post("/proxy/query", json={"question": "test"})
            assert res.status_code == 200
            assert res.json()["sql"] == "SELECT 1;"
            assert mock_client.post.call_args.kwargs["timeout"] == 300.0
