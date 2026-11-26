# Antigravity Milestone Prompt Pack (`human_to_sql` v2)

Use these sequential, copy-pasteable prompts to drive the **Hydrogen** model in **Antigravity** end-to-end without context drift, stubbed code, or broken imports.

## Operating Rules for Antigravity
1. **One milestone per chat/session:** Start a fresh Antigravity session for each milestone so context stays clean and focused.
2. **Never skip the verification gate:** Do not move to the next milestone until the verification command passes with zero failures.
3. **Keep blueprints in the repo:** Save `enterprise_architecture_plan.md` and `test_and_benchmark_plan.md` under `docs/` so Hydrogen can inspect them when referenced.
4. **Hackathon stop-point:** Stopping after **Milestone 5** gives you a complete, Docker Compose end-to-end demo (MySQL + Postgres + Semantic Layer + Self-Correction + Cascade-Aware DML + Hardened Live MCP + Workbench UI + `h2sql` CLI). Run **Milestone 6** for post-hackathon enterprise production.

---

## Milestone 1: Core Contracts, Control-Plane DB & Persisted Topology Graph

**Paste into Antigravity:**

```text
You are implementing Milestone 1 of our v2 enterprise plan for human_to_sql.
Read docs/enterprise_architecture_plan.md (Sections 1, 2, 4, 10) for context, then implement ONLY Milestone 1.

GOAL:
Decouple schema introspection behind a BaseConnector contract and move topology/FK graph persistence out of local JSON files (fk_graph.json) into a Control-Plane DB (PostgreSQL in Docker/Prod with SQLite fallback for local dev).

FILES TO CREATE / UPDATE:
1. schema_rag/connectors/base.py — Define dataclasses/Pydantic models:
   - SchemaEntity (datasource_id, engine, schema_name, name, entity_type, columns, primary_keys, foreign_keys, cascade_edges, indexes, sample_values, content_hash)
   - ForeignKeyRef (source_table, source_col, target_table, target_col, on_delete, on_update)
   - BaseConnector ABC: test_connection(), introspect(), explain_query(sql), run_readonly_query(sql, limit)
2. schema_rag/storage/meta_db.py — SQLAlchemy 2.0 + Alembic-ready metadata store supporting DATABASE_URL (PostgreSQL or sqlite:///./h2sql_meta.db) with tables:
   - datasources (id, name, engine, env_tag, secret_ref, include_patterns, exclude_patterns, created_at)
   - topology_edges (datasource_id, source_entity, target_entity, edge_type, on_delete_action, metadata_json)
   - golden_queries (id, datasource_id, question, canonical_query, explanation, tags_json)
   - glossary_terms (id, datasource_id, term, sql_definition, applies_to_tables_json)
   - mandatory_predicates (id, datasource_id, table_name, predicate_sql, description)
   - query_history (id, datasource_id, question, generated_query, intent, risk_level, created_at)
   - audit_logs (id, actor, channel, datasource_id, query_text, decision, reason, row_count, created_at)
3. schema_rag/db/fk_graph.py — Refactor so NetworkX graph loads/saves from topology_edges in meta_db per datasource_id (keep backward-compatible helper signatures so existing unit tests still pass). Add get_cascade_descendants(table_name) returning all child tables reachable via ON DELETE CASCADE.
4. tests/unit/test_meta_db_and_cascade.py — Unit tests using in-memory SQLite verifying CRUD, topology persistence across re-instantiation, and multi-hop ON DELETE CASCADE traversal.

STRICT CONSTRAINTS:
- No TODOs, no placeholder pass blocks, no breaking changes to existing tests in tests/.
- Keep all dependencies lightweight (sqlalchemy, pydantic, networkx).

VERIFICATION GATE:
Run: pytest tests/unit/ -v
Fix any failures and report the exact pytest output before finishing.
```

---

## Milestone 2: MySQL & PostgreSQL Connectors, Value Profiling, Hash-Diff & Semantic Layer

**Paste into Antigravity:**

```text
You are implementing Milestone 2 of human_to_sql on top of Milestone 1.

GOAL:
Implement Tier-1 relational connectors (MySQL 8+ and PostgreSQL 16+) with write-aware introspection, low-cardinality value profiling, incremental Qdrant hash-diff upserts, and the Phase-1 Semantic Layer (Golden Queries + Glossary + Mandatory Predicates).

FILES TO CREATE / UPDATE:
1. schema_rag/connectors/mysql.py — Implement MySQLConnector(BaseConnector) migrating and upgrading schema_rag/db/mysql_client.py:
   - Extract COLUMN_DEFAULT, EXTRA (auto_increment), IS_NULLABLE, ENUM values, views, and REFERENTIAL_CONSTRAINTS (DELETE_RULE, UPDATE_RULE).
   - Low-cardinality value profiling: for VARCHAR/CHAR/ENUM columns not matching PII patterns (email, phone, ssn, password, token, card, address), sample up to 20 distinct values if cardinality <= 25.
   - Apply include/exclude table regex filters (e.g., skip *_bak_*, tmp_*).
2. schema_rag/connectors/postgres.py — Implement PostgresConnector(BaseConnector) using psycopg/psycopg2:
   - Introspect information_schema + pg_catalog across schemas (tables, views, materialized views, JSONB columns, FK delete rules, value profiling).
3. schema_rag/qdrant_store/upsert.py — Upgrade to incremental hash-diff indexing:
   - Store datasource_id and content_hash in Qdrant payloads.
   - Skip re-embedding unchanged entities; delete stale points for dropped tables; return {inserted, updated, skipped, deleted}.
   - Index Golden Queries and Glossary Terms in dedicated Qdrant payload types (record_type="golden_query" | "glossary_term") scoped by datasource_id.
4. schema_rag/qdrant_store/retriever.py — Update retrieval to filter by datasource_id, respect RBAC allowed_tables (if provided), and return:
   - matched_entities + topology-expanded entities
   - top-3 golden_queries
   - matching glossary_terms + mandatory_predicates for retrieved tables
5. docker-compose.e2e.yml — Add reproducible local containers for MySQL 8.0, PostgreSQL 16, Qdrant, and Postgres MetaDB with healthchecks.
6. tests/integration/test_connectors_live.py — Live integration test (marked @pytest.mark.pr_core) verifying MySQL & Postgres introspection, value profiling, PII exclusion from profiling, and incremental hash-diff (alter 1 column -> assert updated==1, skipped>0).

STRICT CONSTRAINTS:
- Zero stubs or mocked connectors in test_connectors_live.py.
- Keep existing tests/unit/ passing.

VERIFICATION GATE:
Run:
1. pytest tests/unit/ -v
2. docker compose -f docker-compose.e2e.yml up -d --wait
3. pytest tests/integration/test_connectors_live.py -v
Report exact test results before finishing.
```

---

## Milestone 2B: Fix Existing Benchmark Baseline (Quick Checkpoint)

**Paste into Antigravity:**

```text
You are executing Milestone 2B: fixing known accuracy and data bugs in benchmark/ per docs/test_and_benchmark_plan.md (Section 4).

FILES TO UPDATE:
1. benchmark/schema/seed_data.sql & benchmark/generate_suite.py:
   - Fix self-referencing categories.parent_id and employees.manager_id into real 3-level trees (depths 0, 1, 2).
   - Seed intentional NULL rows in customers (segment_id, birth_date, last_name) and addresses (line2).
   - Replace 'Customer Segments 1' with realistic names ('VIP', 'Standard', 'Enterprise') and align expected_sql.
   - Mix alphabetic-only and alphanumeric product names so REGEXP '[0-9]' tests real filtering.
   - Replace hardcoded '2026-07-24' dates with relative date logic or a benchmark --reference-date parameter.
   - Add 10 Phase-1 DML + ON DELETE CASCADE test cases and 10 Phase-2 MCP refusal test cases.
2. benchmark/runner/benchmark_runner.py:
   - Replace wrong_tables() with Table Recall@K and Table Precision@K across both base tables and v_* views.
   - Upgrade compare_rows() to support modes: strict, column_bag, and entity_relaxed.
   - Use sqlglot AST validation instead of raw string prefix checks so leading SQL comments are handled safely while multi-statements are blocked.

VERIFICATION GATE:
Run: python3 benchmark/runner/benchmark_runner.py --dry-run --refresh-expected-results
Confirm zero SQL errors on expected_sql against live MySQL and report updated case counts.
```

---

## Milestone 3: Native `httpx` LLM Router, AST Policy, Self-Correction & Cascade-Aware DML

**Paste into Antigravity:**

```text
You are implementing Milestone 3 of human_to_sql.

GOAL:
Build the lightweight native httpx LLM gateway, sqlglot AST policy engine, bounded 1-2 turn EXPLAIN self-correction loop, and Phase-1 cascade-aware DML dry-run engine.

FILES TO CREATE / UPDATE:
1. schema_rag/llm/gateway.py — Implement native httpx LLMProvider interface + adapters (NO litellm):
   - OllamaProvider
   - OpenAICompatProvider (covers vLLM, LM Studio, Kimi, OpenAI, Groq, GitHub Models, custom gateways)
   - AnthropicProvider
   - ReplayStubProvider (deterministic test stub for zero-flake PR CI)
2. schema_rag/policy/guardrails.py — Implement sqlglot-based AST validator supporting dialects (mysql, postgres):
   - classify_intent(sql, dialect) -> "read" | "dml_insert" | "dml_update" | "dml_delete" | "ddl_blocked"
   - Enforce mandatory_predicates on referenced tables.
   - Detect missing WHERE on UPDATE/DELETE and multi-statement queries.
   - synthesize_dry_run_sql(sql, dialect) -> returns safe SELECT COUNT(*) for single-table UPDATE/DELETE, or None + structural warning for multi-table JOIN/USING statements.
3. schema_rag/pipeline/query_engine.py — Wire full Phase-1 pipeline:
   - Retrieve schemas + FK/cascade graph + top-3 Golden Queries + Glossary + Value Profiles.
   - Generate query via LLMProvider.
   - Closed-loop self-correction: validate via sqlglot AST + connector.explain_query(); if syntax/column error occurs, feed exact error back to LLM (max 2 retries).
   - For DML suggestions: attach cascade_warnings from fk_graph.get_cascade_descendants(), direct-row dry_run_count (labeled "Direct target rows — excludes cascades/triggers"), and transaction_wrapper. Never execute DML.
4. schema_rag/api/app.py — Expose POST /api/v1/query, POST /api/v1/query/stream (SSE stages), and CRUD endpoints for datasources, golden_queries, glossary_terms, and mandatory_predicates.
5. tests/integration/test_dml_rollback_live.py — Live integration tests (with ReplayStubProvider + real MySQL/Postgres):
   - Verify dry_run_count == actual cursor.rowcount inside a rolled-back BEGIN...ROLLBACK transaction.
   - Verify ON DELETE CASCADE parent delete populates cascade_warnings with child table names.
   - Verify self-correction loop recovers from an injected first-turn unknown-column error within <=2 retries.

STRICT CONSTRAINTS:
- Phase-1 API must NEVER commit DML statements to target databases.
- No stubs or skipped assertions.

VERIFICATION GATE:
Run:
1. pytest tests/unit/ -v
2. pytest tests/integration/test_dml_rollback_live.py -v
Report exact test results before finishing.
```

---

## Milestone 4: Hardened Phase-2 Per-DB MCP Server (`mcp-mysql`, `mcp-postgres`) & Adversarial Suite

**Paste into Antigravity:**

```text
You are implementing Milestone 4 of human_to_sql: the hardened Phase-2 Read-Only MCP Data Bridge.

GOAL:
Build mcp_core and per-database MCP servers (mcp-mysql, mcp-postgres) using the official Python MCP SDK (stdio + Streamable HTTP) with 4-layer read-only defense-in-depth, PII evasion blocking, RBAC table/column allowlists, and session row budgets.

FILES TO CREATE:
1. schema_rag/mcp_servers/core/policy.py:
   - Layer 1: Per-session & hourly cumulative row budget tracker + rate limiter.
   - Layer 2: Strict sqlglot AST lock (SELECT/WITH/SHOW/EXPLAIN only, reject multi-statement, reject SELECT *, enforce allowed_tables, and check column_denylist across ALL AST column references including aliases like "SELECT email AS x" and expressions like "CONCAT(phone, '')").
2. schema_rag/mcp_servers/core/pii_redactor.py:
   - Layer 4: Value-based PII scanner redacting emails, phone numbers, SSNs, credit cards, and bearer tokens in returned JSON cell values regardless of column name.
3. schema_rag/mcp_servers/core/base_server.py:
   - Official MCP SDK server wrapper supporting --transport stdio and --transport http (Streamable HTTP + Bearer token/role header).
   - Expose ONLY read-only tools: search_schema (filtered by role allowed_tables), explain_query, and run_<engine>_query.
   - Log every allowed and rejected attempt to audit_logs in meta_db.
4. schema_rag/mcp_servers/engines/mysql_mcp.py & postgres_mcp.py:
   - Enforce DB session read-only mode (SET SESSION TRANSACTION READ ONLY / default_transaction_read_only=on), statement timeout <= 5s, and hard LIMIT <= 100.
5. schema_rag/mcp_servers/entrypoint.py — CLI entrypoint: python -m schema_rag.mcp_servers.entrypoint --engine mysql|postgres --datasource <id> --transport stdio|http
6. tests/integration/test_mcp_security_live.py & tests/integration/test_resilience_live.py:
   - Connect using the real Python MCP client SDK (no mocks).
   - Assert 100% rejection of: INSERT/UPDATE/DELETE/DROP/TRUNCATE/ALTER, "/* select */ DELETE ...", "SELECT 1; DROP TABLE ...", INTO OUTFILE, COPY TO PROGRAM, SELECT *, "SELECT email AS x", "CONCAT(first_name, ':', phone)".
   - Assert Layer-4 value redaction masks emails/phones inside free-text notes columns.
   - Assert restricted tables never appear in search_schema and are blocked on query.
   - Assert rapid paginated queries trigger the session row budget block + audit log entry.
   - Assert 10 concurrent MCP requests and a slow pg_sleep(10) timeout terminate cleanly without hanging.

STRICT CONSTRAINTS:
- Zero write/DML tools exposed in MCP schema.
- 100.0% pass rate required on adversarial security assertions.

VERIFICATION GATE:
Run:
1. pytest tests/integration/test_mcp_security_live.py -v
2. pytest tests/integration/test_resilience_live.py -v
Report exact test results before finishing.
```

---

## Milestone 5: Workbench UI & `h2sql` CLI (Hackathon End-to-End Stop-Point)

**Paste into Antigravity:**

```text
You are implementing Milestone 5 of human_to_sql: the Enterprise Workbench UI and h2sql production CLI.

GOAL:
Deliver a clean, demo-ready Workbench UI and Typer CLI synced with the FastAPI Control Plane so users can ingest schemas, inspect topology graphs, run Phase-1 read/DML queries with SSE progress, and copy ready-to-paste MCP client configs.

FILES TO CREATE / UPDATE:
1. web/ (React + TypeScript + Tailwind + Monaco Editor + React Flow) OR a clean modular Vite build served by FastAPI:
   - Top bar: Datasource selector (engine + env badge), Model/Provider selector, Policy Mode badge.
   - Left pane: Searchable Schema Explorer + interactive React Flow ER/cascade graph (highlight seed tables, expanded FK tables, and ON DELETE CASCADE edges).
   - Center pane: Natural language prompt box, SSE stage progress indicator, Monaco SQL editor, Risk Banner (READ-ONLY / DML SUGGESTION — Copy Only / DDL BLOCKED), Cascade-Aware Dry-Run Impact Card, and read-only result table.
   - Right drawer: Provenance inspector (Golden Queries used, Glossary terms, self-correction trace, audit log feed) + one-click "Copy MCP Config (.vscode/mcp.json)" button.
2. cli/h2sql/main.py (Typer + httpx + rich):
   - h2sql source add / list / test
   - h2sql ingest --source <name> [--incremental] (streams live progress)
   - h2sql ask "<question>" --source <name> (prints formatted query, risk badge, cascade warnings, and Workbench UI deep-link /workbench?q=<query_id>)
   - h2sql mcp --engine <mysql|postgres> --source <name> (launches stdio MCP server)
   - h2sql mcp config --source <name> (prints ready-to-paste JSON for Cursor / VS Code / Claude Code)
3. pyproject.toml — Register console_scripts entry point h2sql = "cli.h2sql.main:app".
4. tests/integration/test_cli_ui_sync_live.py — Run h2sql ingest and h2sql ask via subprocess against the live API, verify query_id deep-link loads cleanly via HTTP/Playwright, and verify h2sql mcp config outputs valid JSON.

VERIFICATION GATE:
Run:
1. pip install -e .
2. h2sql --help
3. pytest tests/integration/test_cli_ui_sync_live.py -v
Confirm the full Docker Compose stack (API + UI + MySQL + Postgres + Qdrant + MCP) runs cleanly end-to-end.
```

---

## Milestone 6: Elasticsearch Connector, Isolated Workers & Production Helm Charts (Post-Hackathon Enterprise)

**Paste into Antigravity (only after Milestones 1–5 are green):**

```text
You are implementing Milestone 6 of human_to_sql: Tier-1 Elasticsearch/OpenSearch support, zero-credential API isolation, and external-first production Helm charts.

GOAL:
Add Elasticsearch/OpenSearch (ES|QL + Query DSL), move target DB introspection/dry-runs into isolated per-engine workers so schema-rag-api never holds target DB credentials, and upgrade helm/schema-rag/ for production HA + NetworkPolicy isolation.

FILES TO CREATE / UPDATE:
1. schema_rag/connectors/elasticsearch.py & schema_rag/mcp_servers/engines/elasticsearch_mcp.py:
   - Introspect /_cat/indices, /_alias, /_data_stream, /_mapping with field-group sub-chunking for 200+ field mappings.
   - Generate ES|QL and Query DSL; Phase-2 MCP allows only /_search, /_count, /_esql and blocks _delete_by_query, _update_by_query, _reindex, and Painless scripts.
2. schema_rag/workers/engine_worker.py:
   - Scoped per-engine worker process executing introspect(), explain_query(), and dry-run count queries so schema-rag-api stores only secret_ref URIs and never connects directly to target databases.
3. helm/schema-rag/:
   - values.yaml: Default to externalPostgres.enabled=true, externalRedis.enabled=true, externalQdrant.enabled=true, e2eSandbox.enabled=false.
   - values-local.yaml, values-e2e-test.yaml, values-airgap.yaml.
   - templates/deployment-api.yaml, deployment-ui.yaml, deployment-worker.yaml, deployment-mcp.yaml (range-templated per engine with dedicated ServiceAccount and scoped Secret), externalsecret.yaml, networkpolicy.yaml (block schema-rag-api egress to target DBs; restrict each mcp-<engine> pod to its target port only), and tests/test-e2e-smoke.yaml.
4. tests/e2e_helm/test_helm_cluster.py — Run helm lint and helm template across all 4 values profiles, plus NetworkPolicy isolation assertions when a kind/k3s cluster is present.

VERIFICATION GATE:
Run:
1. helm lint helm/schema-rag/
2. helm template schema-rag helm/schema-rag/ -f helm/schema-rag/values.yaml > /dev/null
3. helm template schema-rag helm/schema-rag/ -f helm/schema-rag/values-e2e-test.yaml > /dev/null
4. pytest tests/unit/ tests/integration/ -v
Report exact results before finishing.
```
