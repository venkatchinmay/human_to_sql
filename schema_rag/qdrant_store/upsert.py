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
    comment: str = "",
    table_type: str = "BASE TABLE",
    indexes: list[dict[str, Any]] | None = None,
) -> str:
    """Build a semantic text representation of a table or view for embedding."""
    col_strs = []
    for c in columns:
        desc = f"{c['name']} ({c['type']})"
        if c.get("comment"):
            desc += f" - {c['comment']}"
        col_strs.append(desc)

    fk_strs = [f"{e['column']} -> {e['ref_table']}.{e['ref_column']}" for e in fk_edges]

    kind_prefix = "view" if table_type == "VIEW" else "table"
    parts = [f"{kind_prefix}: {table_name}"]
    if comment and comment != "VIEW":
        parts.append(f"description: {comment}")
    if col_strs:
        parts.append(f"columns: {', '.join(col_strs)}")
    if indexes:
        idx_strs = [
            f"{idx['type']} {idx['name']} ({', '.join(idx['columns'])})"
            for idx in indexes
            if idx.get("name") != "PRIMARY"
        ]
        if idx_strs:
            parts.append(f"indexes: {'; '.join(idx_strs)}")
    if fk_strs:
        parts.append(f"foreign keys: {', '.join(fk_strs)}")
    return "\n".join(parts)


def build_ddl(
    table_name: str,
    columns: list[dict[str, Any]],
    fk_edges: list[dict[str, str]],
    comment: str = "",
    table_type: str = "BASE TABLE",
    indexes: list[dict[str, Any]] | None = None,
    view_definition: str = "",
) -> str:
    """Build a concise DDL string for the LLM prompt context."""
    if table_type == "VIEW":
        col_defs = [f"  {c['name']} {c['type']}" for c in columns]
        header = f"-- VIEW {table_name}"
        if view_definition:
            header += f"\n-- Definition: {view_definition}"
        return f"{header}\nCREATE VIEW {table_name} (\n" + ",\n".join(col_defs) + "\n);"

    pri_count = sum(1 for c in columns if c.get("key") == "PRI")
    col_defs: list[str] = []
    for c in columns:
        nullable = "" if c.get("nullable", True) else " NOT NULL"
        key = " PRIMARY KEY" if c.get("key") == "PRI" and pri_count == 1 else ""
        col_comment = f" /* {c['comment']} */" if c.get("comment") else ""
        col_defs.append(f"  {c['name']} {c['type']}{nullable}{key}{col_comment}")

    constraint_defs: list[str] = []
    if pri_count > 1:
        pri_cols = [c["name"] for c in columns if c.get("key") == "PRI"]
        constraint_defs.append(f"  PRIMARY KEY ({', '.join(pri_cols)})")

    if indexes:
        for idx in indexes:
            iname = idx.get("name", "")
            cols = ", ".join(idx.get("columns", []))
            if not cols or iname == "PRIMARY":
                continue
            if idx.get("type") == "FULLTEXT":
                constraint_defs.append(f"  FULLTEXT KEY {iname} ({cols})")
            elif idx.get("unique"):
                constraint_defs.append(f"  UNIQUE KEY {iname} ({cols})")

    for e in fk_edges:
        constraint_defs.append(
            f"  FOREIGN KEY ({e['column']}) REFERENCES {e['ref_table']}({e['ref_column']})"
        )

    all_lines = col_defs + constraint_defs
    prefix = f"-- {comment}\n" if comment else ""
    return f"{prefix}CREATE TABLE {table_name} (\n" + ",\n".join(all_lines) + "\n);"


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
    batch_size: int = 64,
    collection_name: str = QDRANT_COLLECTION,
) -> int:
    """Embed and upsert one point per table.  Returns the count of points upserted."""
    points: list[PointStruct] = []

    for table_name, table_info in tables.items():
        columns = table_info["columns"]
        fk_edges = fk_map.get(table_name, [])
        comment = table_info.get("comment", "")
        table_type = table_info.get("table_type", "BASE TABLE")
        indexes = table_info.get("indexes", [])
        view_definition = table_info.get("view_definition", "")

        doc_text = build_doc_text(
            table_name,
            columns,
            fk_edges,
            comment=comment,
            table_type=table_type,
            indexes=indexes,
        )
        ddl = build_ddl(
            table_name,
            columns,
            fk_edges,
            comment=comment,
            table_type=table_type,
            indexes=indexes,
            view_definition=view_definition,
        )

        # Dense embedding
        dense_vec = dense_enc.encode_doc(doc_text)
        if dense_vec and isinstance(dense_vec[0], list):
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
                    "table_type": table_type,
                    "doc_text": doc_text,
                    "ddl": ddl,
                    "columns": [c["name"] for c in columns],
                    "fk_edges": [f"{e['column']} -> {e['ref_table']}.{e['ref_column']}" for e in fk_edges],
                },
            )
        )

    for start in range(0, len(points), batch_size):
        batch = points[start : start + batch_size]
        client.upsert(collection_name=collection_name, points=batch)

    logger.info("Upserted %d points to %s", len(points), collection_name)
    return len(points)
