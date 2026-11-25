"""FastAPI application — REST API for schema RAG query and ingestion."""

from __future__ import annotations

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel

from schema_rag.config import APP_PORT, FK_GRAPH_PATH, LOG_LEVEL, QDRANT_COLLECTION, QDRANT_URL
from schema_rag.embeddings.dense_encoder import DenseEncoder
from schema_rag.embeddings.sparse_encoder import SparseEncoder
from schema_rag.llm.sql_generator import generate_sql
from schema_rag.retrieval.prompt_builder import build_sql_prompt
from schema_rag.retrieval.retriever import SchemaRetriever

logging.basicConfig(level=getattr(logging, LOG_LEVEL.upper(), logging.INFO))
logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Shared state (set during lifespan)
# ---------------------------------------------------------------------------
_retriever: SchemaRetriever | None = None


def get_retriever() -> SchemaRetriever:
    if _retriever is None:
        raise HTTPException(status_code=503, detail="Application not initialized")
    return _retriever


def _ensure_fk_graph() -> None:
    """Best-effort FK graph hydration from MySQL if the persisted file is missing."""
    if FK_GRAPH_PATH.exists():
        return
    try:
        from schema_rag.db.fk_graph import build_fk_graph, save_fk_graph
        from schema_rag.db.mysql_client import fetch_fk_edges, get_connection

        conn = get_connection()
        try:
            fk_map = fetch_fk_edges(conn)
        finally:
            conn.close()
        FK_GRAPH_PATH.parent.mkdir(parents=True, exist_ok=True)
        save_fk_graph(build_fk_graph(fk_map), FK_GRAPH_PATH)
    except Exception as exc:  # noqa: BLE001 - graceful startup when MySQL is unavailable
        logger.warning("Could not hydrate FK graph at startup: %s", exc)


# ---------------------------------------------------------------------------
# Lifespan — load models once at startup
# ---------------------------------------------------------------------------


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load embedding models and connect to Qdrant on startup."""
    logger.info("Starting application — loading models...")
    _ensure_fk_graph()
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
    top_k: int | None = None

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
    question = req.question.strip()
    if not question:
        raise HTTPException(status_code=400, detail="Question must not be empty")

    retriever = get_retriever()
    try:
        result = retriever.retrieve(question, top_k=req.top_k) if req.top_k else retriever.retrieve(question)
        prompt = build_sql_prompt(question, result["ddl_context"])
        sql = generate_sql(prompt)
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Query failed: %s", exc)
        raise HTTPException(status_code=502, detail=f"Query processing failed: {exc}") from exc

    return QueryResponse(
        sql=sql,
        seed_tables=result["seed_tables"],
        expanded_tables=result["expanded_tables"],
    )


@app.post("/ingest", response_model=IngestResponse)
def ingest() -> IngestResponse:
    """Trigger a full schema re-ingestion (connects to MySQL)."""
    from qdrant_client import QdrantClient
    from schema_rag.db.fk_graph import build_fk_graph, save_fk_graph
    from schema_rag.db.mysql_client import fetch_fk_edges, fetch_tables, get_connection
    from schema_rag.qdrant_store.collection import recreate_collection
    from schema_rag.qdrant_store.upsert import upsert_tables

    retriever = get_retriever()

    try:
        conn = get_connection()
        try:
            tables = fetch_tables(conn)
            fk_map = fetch_fk_edges(conn)
        finally:
            conn.close()

        FK_GRAPH_PATH.parent.mkdir(parents=True, exist_ok=True)
        G = build_fk_graph(fk_map)
        save_fk_graph(G, FK_GRAPH_PATH)

        qdrant = QdrantClient(url=QDRANT_URL)
        recreate_collection(qdrant)

        upsert_tables(qdrant, tables, fk_map, retriever._dense_enc, retriever._sparse_enc)
        retriever.reload_fk_graph(FK_GRAPH_PATH)

        total = qdrant.count(collection_name=QDRANT_COLLECTION)
    except HTTPException:
        raise
    except Exception as exc:
        logger.exception("Ingestion failed: %s", exc)
        raise HTTPException(status_code=502, detail=f"Ingestion failed: {exc}") from exc

    return IngestResponse(
        message="Ingestion complete",
        tables=len(tables),
        points=total.count,
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("schema_rag.api.app:app", host="0.0.0.0", port=APP_PORT, reload=False)
