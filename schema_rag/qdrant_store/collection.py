"""Qdrant collection management — idempotent create."""

from __future__ import annotations

import logging

from qdrant_client import QdrantClient
from qdrant_client.models import Distance, SparseVectorParams, VectorParams

from schema_rag.config import DENSE_DIM, QDRANT_COLLECTION

logger = logging.getLogger(__name__)


def create_collection(client: QdrantClient, dense_dim: int = DENSE_DIM) -> None:
    """Create the schema collection (skip if it already exists)."""
    collection_name = QDRANT_COLLECTION

    if client.collection_exists(collection_name):
        logger.info("Collection %s already exists — skipping creation.", collection_name)
        return

    client.create_collection(
        collection_name=collection_name,
        vectors_config={
            "dense": VectorParams(size=dense_dim, distance=Distance.COSINE),
        },
        sparse_vectors_config={
            "sparse": SparseVectorParams(),
        },
    )
    logger.info("Created collection %s (dense_dim=%d)", collection_name, dense_dim)


def recreate_collection(client: QdrantClient, dense_dim: int = DENSE_DIM) -> None:
    """Drop and recreate the collection — useful for full re-ingest."""
    collection_name = QDRANT_COLLECTION
    if client.collection_exists(collection_name):
        client.delete_collection(collection_name)
        logger.info("Dropped collection %s", collection_name)
    create_collection(client, dense_dim)
