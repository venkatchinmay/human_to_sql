# Text-to-SQL Benchmark Suite

This directory contains a deterministic e-commerce / retail logistics benchmark
for the Schema RAG text-to-SQL system.

## Artifacts

- `schema/schema.sql` - 100-table MySQL schema with indexes, constraints, full-text index, views, and connected foreign keys.
- `schema/seed_data.sql` - deterministic seed data for every table.
- `schema/schema_manifest.json` - machine-readable table, column, FK, index, and view manifest.
- `testcases/test_cases.csv` - 147 natural-language benchmark cases.
- `testcases/coverage_report.md` - concept-to-test coverage summary.
- `runner/benchmark_runner.py` - dry-run verifier and benchmark runner.

## Quick Local Run (Docker Compose / Local MySQL)

```bash
# 1. Regenerate benchmark schema, seed data, manifest, and test cases
python -m benchmark.generate_suite

# 2. Load schema and seed data into MySQL
mysql -h 127.0.0.1 -P 3307 -uroot -prootpassword schema_rag_test < benchmark/schema/schema.sql
mysql -h 127.0.0.1 -P 3307 -uroot -prootpassword schema_rag_test < benchmark/schema/seed_data.sql

# 3. Index MySQL schema + views into Qdrant via the API
curl -X POST http://localhost:8000/ingest

# 4. Cache expected results from ground-truth SQL
python -m benchmark.runner.benchmark_runner --progress --dry-run --refresh-expected-results \
  --mysql-host 127.0.0.1 --mysql-port 3307 --mysql-user root --mysql-password rootpassword --mysql-database schema_rag_test

# 5. Run the benchmark against the API
python -m benchmark.runner.benchmark_runner --progress --adapter http --adapter-url http://localhost:8000/query \
  --llm-timeout-seconds 300 --mysql-host 127.0.0.1 --mysql-port 3307 --mysql-user root --mysql-password rootpassword --mysql-database schema_rag_test
```

## Kubernetes Runbook

```bash
# Step 1: Go to project root
cd /path/to/human_to_sql

# Step 2: Generate benchmark files locally
python3 -m benchmark.generate_suite 

# Step 3: Drop existing views and tables from MySQL database
kubectl exec schema-rag-mysql-0 -- mysql -uroot -prootpassword schema_rag_test -e "SET SESSION group_concat_max_len=1000000; SET FOREIGN_KEY_CHECKS=0; SELECT GROUP_CONCAT(TABLE_NAME SEPARATOR ', ') INTO @view_list FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='VIEW'; SET @drop_views=IF(@view_list IS NULL, 'SELECT 1', CONCAT('DROP VIEW IF EXISTS ', @view_list)); PREPARE s1 FROM @drop_views; EXECUTE s1; DEALLOCATE PREPARE s1; SELECT GROUP_CONCAT(TABLE_NAME SEPARATOR ', ') INTO @table_list FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='BASE TABLE'; SET @drop_tables=IF(@table_list IS NULL, 'SELECT 1', CONCAT('DROP TABLE IF EXISTS ', @table_list)); PREPARE s2 FROM @drop_tables; EXECUTE s2; DEALLOCATE PREPARE s2; SET FOREIGN_KEY_CHECKS=1;"


# Step 4: Copy generated schema and seed data into MySQL pod
kubectl cp benchmark/schema/schema.sql schema-rag-mysql-0:/tmp/benchmark_schema.sql
kubectl cp benchmark/schema/seed_data.sql schema-rag-mysql-0:/tmp/benchmark_seed_data.sql


# Step 5: Load schema and seed data into MySQL
kubectl exec schema-rag-mysql-0 -- sh -c "mysql -uroot -prootpassword schema_rag_test < /tmp/benchmark_schema.sql && mysql -uroot -prootpassword schema_rag_test < /tmp/benchmark_seed_data.sql"


# Step 6: Verify MySQL loaded 100 tables, 4 views, 0 empty base tables
kubectl exec schema-rag-mysql-0 -- mysql -uroot -prootpassword schema_rag_test -N -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='BASE TABLE'; SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='VIEW'; SELECT SUM(table_rows = 0) FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_TYPE='BASE TABLE';"

# Step 7: Index the new MySQL schema into Qdrant through the app ingest endpoint
kubectl exec schema-rag-6547fc87d-b6zqn -- python -c "import httpx; r=httpx.post('http://localhost:8000/ingest', timeout=600); print(r.status_code); print(r.text)"
```
200
{"message":"Ingestion complete","tables":104,"points":104}

```
# Step 8: Remove old benchmark copy from app pod
kubectl exec schema-rag-6547fc87d-b6zqn -- rm -rf /tmp/benchmark


# Step 9: Copy benchmark runner/files to app pod
kubectl cp benchmark schema-rag-6547fc87d-b6zqn:/tmp/benchmark

# Step 10 : Generate expected results inside pod
kubectl exec -it schema-rag-6547fc87d-b6zqn -- sh -c "cd /tmp && PYTHONUNBUFFERED=1 python -m benchmark.runner.benchmark_runner --progress --dry-run --refresh-expected-results --mysql-host schema-rag-mysql --mysql-user root --mysql-password rootpassword --mysql-database schema_rag_test"

# Step 11: RUN THE ACTUAL TEST SUITE with live progress
kubectl exec -it schema-rag-6547fc87d-b6zqn -- sh -c "cd /tmp && PYTHONUNBUFFERED=1 python -m benchmark.runner.benchmark_runner --progress --adapter http --adapter-url http://localhost:8000/query --llm-timeout-seconds 300 --mysql-host schema-rag-mysql --mysql-user root --mysql-password rootpassword --mysql-database schema_rag_test"

# Step 12: RUN THE ACTUAL TEST SUITE with live progress
kubectl exec -it schema-rag-6547fc87d-b6zqn -- sh -c "cd /tmp && PYTHONUNBUFFERED=1 python -m benchmark.runner.benchmark_runner --progress --adapter http --adapter-url http://localhost:8000/query --llm-timeout-seconds 60 --mysql-host schema-rag-mysql --mysql-user root --mysql-password rootpassword --mysql-database schema_rag_test"


# Step 13: View final markdown report
kubectl exec schema-rag-6547fc87d-b6zqn -- cat /tmp/benchmark/runner/reports/report.md


kubectl patch deployment schema-rag-ollama --type='json' -p='[
  {"op":"replace","path":"/spec/template/spec/containers/0/resources/limits/cpu","value":"3"},
  {"op":"replace","path":"/spec/template/spec/containers/0/resources/limits/memory","value":"5Gi"},
  {"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/cpu","value":"2"},
  {"op":"replace","path":"/spec/template/spec/containers/0/resources/requests/memory","value":"4Gi"}
]'
