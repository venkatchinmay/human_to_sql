# MySQL Schema RAG for Text-to-SQL

A retrieval-augmented generation system that takes a natural-language question,
retrieves the minimal relevant subset of MySQL tables (with FK relationships),
and generates SQL via a local LLM.

## Architecture

```
User Question
    │
    ▼
┌──────────────┐    ┌─────────────┐
│  Dense       │    │  Sparse     │
│  (BGE-small) │    │  (SPLADE)   │
└──────┬───────┘    └──────┬──────┘
       │                   │
       ▼                   ▼
┌──────────────────────────────────┐
│  Qdrant Hybrid Search           │
│  (Dense Prefetch + Sparse      │
│   Prefetch → RRF Fusion)        │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  FK Graph Expansion             │
│  (NetworkX DiGraph, bidirectional)
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  Prompt Builder                  │
│  (DDL context + rules + question) │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│  LLM (Ollama — Gemma 2B/3 1B)   │
└──────────────┬───────────────────┘
               │
               ▼
         SQL Output
```

## Quick Start

### Option 1: Docker Compose (local development)

```bash
# Copy and edit environment
cp .env.example .env
# Edit .env with your MySQL database name, password, etc.

# Start all services
docker compose up -d

# Wait for services to be healthy
docker compose ps

# Trigger schema ingestion
curl -X POST http://localhost:8000/ingest

# Ask a question
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{"question": "Show total revenue by customer for last month"}'
```

### Option 2: Helm (Kubernetes)

```bash
# Install with default values
helm install schema-rag ./helm/schema-rag

# Install for local Kubernetes (minikube/kind)
helm install schema-rag ./helm/schema-rag -f helm/schema-rag/values-local.yaml

# Check status
kubectl get pods -l app.kubernetes.io/instance=schema-rag
kubectl logs -l app.kubernetes.io/name=schema-rag-app --tail=50

# Query the service
kubectl port-forward svc/schema-rag 8000:8000
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{"question": "List all products with stock below 10"}'

# Uninstall
helm uninstall schema-rag
```

### Option 3: Run locally (Python)

```bash
pip install -r requirements.txt

# Set up .env
cp .env.example .env

# Run ingestion
python -m schema_rag.scripts.ingest

# Run a query
python -m schema_rag.scripts.query "Show total revenue by customer"

# Or start the API server
uvicorn schema_rag.api.app:app --reload --port 8000
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `GET` | `/health` | Health check |
| `POST` | `/query` | Ask a question → get SQL |
| `POST` | `/ingest` | Trigger schema ingestion |

### POST /query

**Request:**
```json
{"question": "Show total revenue by customer for last month"}
```

**Response:**
```json
{
  "sql": "SELECT u.username, SUM(o.total_amount) AS revenue ...",
  "seed_tables": ["orders"],
  "expanded_tables": ["orders", "users"]
}
```

## Configuration

All configuration is via environment variables (see `.env.example`):

| Variable | Default | Description |
|----------|---------|-------------|
| `MYSQL_HOST` | `localhost` | MySQL host |
| `MYSQL_PORT` | `3306` | MySQL port |
| `MYSQL_USER` | `root` | MySQL user |
| `MYSQL_PASSWORD` | *(empty)* | MySQL password |
| `MYSQL_DATABASE` | `your_database` | Target database |
| `QDRANT_URL` | `http://localhost:6333` | Qdrant server URL |
| `QDRANT_COLLECTION` | `mysql_schema` | Qdrant collection name |
| `DENSE_MODEL` | `BAAI/bge-small-en-v1.5` | Dense embedding model |
| `SPARSE_MODEL` | `naver/splade-v3-small` | Sparse embedding model |
| `OLLAMA_URL` | `http://localhost:11434` | Ollama server URL |
| `OLLAMA_MODEL` | `gemma2:2b` | LLM model for SQL generation |
| `FK_EXPAND_DEPTH` | `1` | FK graph expansion depth |
| `TOP_K_RETRIEVAL` | `10` | Candidates per prefetch |
| `TOP_K_FINAL` | `5` | Final results after RRF fusion |

## Helm Chart Values

Key configurable values (see `helm/schema-rag/values.yaml`):

- `app.enabled` — toggle the application deployment
- `app.image` — image repository and tag
- `app.resources` — CPU/memory requests and limits
- `mysql.enabled` / `mysql.auth` / `mysql.persistence` — MySQL settings
- `qdrant.enabled` / `qdrant.persistence` — Qdrant settings
- `ollama.enabled` / `ollama.model` / `ollama.persistence` — Ollama settings
- `ingress.enabled` — expose via Ingress

## Testing

```bash
# Unit tests (mocked — no external services needed)
pytest tests/ -v

# Run a specific test file
pytest tests/test_fk_graph.py -v
```

## Project Structure

```
├── schema_rag/
│   ├── config.py              # Central configuration
│   ├── api/
│   │   └── app.py             # FastAPI application
│   ├── db/
│   │   ├── mysql_client.py   # MySQL introspection
│   │   └── fk_graph.py       # FK graph (NetworkX)
│   ├── embeddings/
│   │   ├── dense_encoder.py   # BGE dense embeddings
│   │   └── sparse_encoder.py  # SPLADE sparse embeddings
│   ├── qdrant_store/
│   │   ├── collection.py     # Qdrant collection management
│   │   └── upsert.py         # Embed + upsert tables
│   ├── retrieval/
│   │   ├── retriever.py       # Hybrid search + FK expansion
│   │   └── prompt_builder.py # LLM prompt assembly
│   ├── llm/
│   │   └── sql_generator.py  # Ollama SQL generation
│   └── scripts/
│       ├── ingest.py          # CLI: schema ingestion
│       └── query.py           # CLI: question → SQL
├── tests/
│   ├── test_fk_graph.py
│   ├── test_retriever.py
│   └── fixtures/
│       └── sample_schema.sql
├── helm/schema-rag/           # Kubernetes Helm chart
├── Dockerfile
├── docker-compose.yml
├── Makefile
└── requirements.txt
```

## License

MIT
