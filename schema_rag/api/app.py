"""FastAPI application — REST API for schema RAG query and ingestion."""

from __future__ import annotations

import logging
from contextlib import asynccontextmanager
from typing import Any

from fastapi import FastAPI
from pydantic import BaseModel

from schema_rag.config import APP_PORT, QDRANT_URL
from schema_rag.embeddings.dense_encoder import DenseEncoder
from schema_rag.embeddings.sparse_encoder import SparseEncoder
from schema_rag.llm.sql_generator import generate_sql
from schema_rag.retrieval.prompt_builder import build_sql_prompt
from schema_rag.retrieval.retriever import SchemaRetriever

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Shared state (set during lifespan)
# ---------------------------------------------------------------------------
_retriever: SchemaRetriever | None = None


def get_retriever() -> SchemaRetriever:
    if _retriever is None:
        raise RuntimeError("Application not initialized — call /health first")
    return _retriever


# ---------------------------------------------------------------------------
# Lifespan — load models once at startup
# ---------------------------------------------------------------------------


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load embedding models and connect to Qdrant on startup."""
    logger.info("Starting application — loading models...")
    dense_enc = DenseEncoder()
    sparse_enc = SparseEncoder()

    from qdrant_client import QdrantClient
    qdrant = QdrantClient(url=QDRANT_URL)

    global _retriever  # noqa: PLW0603
    _retriever = SchemaRetriever(qdrant, dense_enc, sparse_enc)
    logger.info("Application ready.")
    yield
    logger.info("Shutting down.")


# ---------------------------------------------------------------------------
# App
# ---------------------------------------------------------------------------
app = FastAPI(
    title="MySQL Schema RAG",
    description="Text-to-SQL via schema retrieval and LLM generation",
    version="0.1.0",
    lifespan=lifespan,
)


# ---------------------------------------------------------------------------
# Request / Response models
# ---------------------------------------------------------------------------

class QueryRequest(BaseModel):
    question: str

class QueryResponse(BaseModel):
    sql: str
    seed_tables: list[str]
    expanded_tables: list[str]

class IngestResponse(BaseModel):
    message: str
    tables: int
    points: int

class HealthResponse(BaseModel):
    status: str


# ---------------------------------------------------------------------------
# Endpoints
# ---------------------------------------------------------------------------

@app.get("/health", response_model=HealthResponse)
async def health():
    return HealthResponse(status="ok")


@app.post("/query", response_model=QueryResponse)
def query(req: QueryRequest) -> QueryResponse:
    retriever = get_retriever()
    result = retriever.retrieve(req.question)

    prompt = build_sql_prompt(req.question, result["ddl_context"])
    sql = generate_sql(prompt)

    return QueryResponse(
        sql=sql,
        seed_tables=result["seed_tables"],
        expanded_tables=result["expanded_tables"],
    )


@app.post("/ingest", response_model=IngestResponse)
def ingest() -> IngestResponse:
    """Trigger a full schema re-ingestion (connects to MySQL)."""
    from qdrant_client import QdrantClient
    from schema_rag.config import FK_GRAPH_PATH
    from schema_rag.db.fk_graph import build_fk_graph, save_fk_graph
    from schema_rag.db.mysql_client import fetch_fk_edges, fetch_tables, get_connection
    from schema_rag.qdrant_store.collection import recreate_collection
    from schema_rag.qdrant_store.upsert import upsert_tables

    conn = get_connection()
    tables = fetch_tables(conn)
    fk_map = fetch_fk_edges(conn)
    conn.close()

    G = build_fk_graph(fk_map)
    save_fk_graph(G, FK_GRAPH_PATH)

    qdrant = QdrantClient(url=QDRANT_URL)
    recreate_collection(qdrant)

    # Use the already-loaded encoders from the retriever
    retriever = get_retriever()
    count = upsert_tables(qdrant, tables, fk_map, retriever._dense_enc, retriever._sparse_enc)
    
    # Reload the newly generated FK graph into the retriever
    from schema_rag.db.fk_graph import load_fk_graph
    retriever._fk_graph = load_fk_graph(FK_GRAPH_PATH)

    total = qdrant.count(collection_name="mysql_schema")
    return IngestResponse(
        message="Ingestion complete",
        tables=len(tables),
        points=total.count,
    )


if __name__ == "__main__":
    import uvicorn
    logging.basicConfig(level=logging.INFO)
    uvicorn.run("schema_rag.api.app:app", host="0.0.0.0", port=APP_PORT, reload=False)
