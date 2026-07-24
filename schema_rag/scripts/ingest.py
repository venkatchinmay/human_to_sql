#!/usr/bin/env python3
"""CLI: one-time ingestion — introspect MySQL schema → embed → upsert to Qdrant."""

from __future__ import annotations

import sys
import time

from schema_rag.config import FK_GRAPH_PATH, QDRANT_COLLECTION, QDRANT_URL
from schema_rag.db.fk_graph import build_fk_graph, save_fk_graph
from schema_rag.db.mysql_client import fetch_fk_edges, fetch_tables, get_connection
from schema_rag.embeddings.dense_encoder import DenseEncoder
from schema_rag.embeddings.sparse_encoder import SparseEncoder
from schema_rag.qdrant_store.collection import recreate_collection
from schema_rag.qdrant_store.upsert import upsert_tables


def main() -> None:
    print("=== Schema RAG Ingestion ===")

    # 1. Connect to MySQL and introspect
    print("[1/5] Connecting to MySQL...")
    conn = get_connection()
    tables = fetch_tables(conn)
    fk_map = fetch_fk_edges(conn)
    conn.close()
    print(f"      Found {len(tables)} tables, "
          f"{sum(len(v) for v in fk_map.values())} FK edges.")

    if not tables:
        print("ERROR: No tables found. Check MYSQL_DATABASE setting.")
        sys.exit(1)

    # 2. Build and save FK graph
    print("[2/5] Building FK graph...")
    G = build_fk_graph(fk_map)
    save_fk_graph(G, FK_GRAPH_PATH)
    print(f"      Saved FK graph to {FK_GRAPH_PATH}")

    # 3. Connect to Qdrant
    print("[3/5] Connecting to Qdrant...")
    from qdrant_client import QdrantClient
    qdrant = QdrantClient(url=QDRANT_URL)

    # Recreate collection for clean ingest
    recreate_collection(qdrant)

    # 4. Load embedding models
    print("[4/5] Loading embedding models (this may take a moment)...")
    t0 = time.time()
    dense_enc = DenseEncoder()
    sparse_enc = SparseEncoder()
    print(f"      Models loaded in {time.time() - t0:.1f}s")

    # 5. Embed and upsert
    print("[5/5] Embedding and upserting tables...")
    count = upsert_tables(qdrant, tables, fk_map, dense_enc, sparse_enc)

    # Verify
    total = qdrant.count(collection_name=QDRANT_COLLECTION)
    print(f"      Upserted {count} points.")
    print(f"      Collection now has {total.count} points.")

    print("=== Ingestion complete ===")


if __name__ == "__main__":
    main()
