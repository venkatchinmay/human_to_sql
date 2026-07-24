"""Qdrant upsert — embed table documents and store them as points."""

from __future__ import annotations

import logging
import uuid
from typing import Any

from qdrant_client import QdrantClient
from qdrant_client.models import PointStruct, SparseVector

from schema_rag.config import QDRANT_COLLECTION
from schema_rag.embeddings.dense_encoder import DenseEncoder
from schema_rag.embeddings.sparse_encoder import SparseEncoder

logger = logging.getLogger(__name__)

# Namespace used for deterministic UUID5 generation
_UUID_NAMESPACE = uuid.UUID("6ba7b810-9dad-11d1-80b4-00c04fd430c8")


# ---------------------------------------------------------------------------
# Text builders
# ---------------------------------------------------------------------------


def build_doc_text(
    table_name: str,
    columns: list[dict[str, Any]],
    fk_edges: list[dict[str, str]],
) -> str:
    """Build a semantic text representation of a table for embedding."""
    col_strs = [f"{c['name']} ({c['type']})" for c in columns]
    fk_strs = [f"{e['column']} -> {e['ref_table']}.{e['ref_column']}" for e in fk_edges]

    parts = [f"table: {table_name}"]
    if col_strs:
        parts.append(f"columns: {', '.join(col_strs)}")
    if fk_strs:
        parts.append(f"foreign keys: {', '.join(fk_strs)}")
    return "\n".join(parts)


def build_ddl(
    table_name: str,
    columns: list[dict[str, Any]],
    fk_edges: list[dict[str, str]],
) -> str:
    """Build a DDL string for the LLM prompt context."""
    col_defs: list[str] = []
    for c in columns:
        nullable = "" if c["nullable"] else " NOT NULL"
        key = ""
        if c["key"] == "PRI":
            key = " PRIMARY KEY"
        col_defs.append(f"  {c['name']} {c['type']}{nullable}{key}")

    fk_defs: list[str] = []
    for e in fk_edges:
        fk_defs.append(
            f"  FOREIGN KEY ({e['column']}) REFERENCES {e['ref_table']}({e['ref_column']})"
        )

    all_lines = col_defs + fk_defs
    return f"CREATE TABLE {table_name} (\n" + ",\n".join(all_lines) + "\n);"


# ---------------------------------------------------------------------------
# Upsert
# ---------------------------------------------------------------------------


def _table_point_id(table_name: str) -> str:
    """Deterministic UUID5 from table name for idempotent upserts."""
    return str(uuid.uuid5(_UUID_NAMESPACE, table_name))


def upsert_tables(
    client: QdrantClient,
    tables: dict[str, dict[str, Any]],
    fk_map: dict[str, list[dict[str, str]]],
    dense_enc: DenseEncoder,
    sparse_enc: SparseEncoder,
) -> int:
    """Embed and upsert one point per table.  Returns the count of points upserted."""
    points: list[PointStruct] = []

    for table_name, table_info in tables.items():
        columns = table_info["columns"]
        fk_edges = fk_map.get(table_name, [])

        doc_text = build_doc_text(table_name, columns, fk_edges)
        ddl = build_ddl(table_name, columns, fk_edges)

        # Dense embedding
        dense_vec = dense_enc.encode_doc(doc_text)
        if isinstance(dense_vec[0], list):
            dense_vec = dense_vec[0]  # unwrap for single text

        # Sparse embedding
        sparse_data = sparse_enc.encode(doc_text)
        sparse_vec = SparseVector(
            indices=sparse_data["indices"],
            values=sparse_data["values"],
        )

        point_id = _table_point_id(table_name)
        points.append(
            PointStruct(
                id=point_id,
                vector={
                    "dense": dense_vec,
                    "sparse": sparse_vec,
                },
                payload={
                    "table_name": table_name,
                    "doc_text": doc_text,
                    "ddl": ddl,
                    "columns": [c["name"] for c in columns],
                    "fk_edges": [f"{e['column']} -> {e['ref_table']}.{e['ref_column']}" for e in fk_edges],
                },
            )
        )

    client.upsert(collection_name=QDRANT_COLLECTION, points=points)
    logger.info("Upserted %d points to %s", len(points), QDRANT_COLLECTION)
    return len(points)
