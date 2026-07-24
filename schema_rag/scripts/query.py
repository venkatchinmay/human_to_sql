#!/usr/bin/env python3
"""CLI: ask a natural-language question, get a SQL query back."""

from __future__ import annotations

import sys

from qdrant_client import QdrantClient

from schema_rag.config import QDRANT_COLLECTION, QDRANT_URL
from schema_rag.embeddings.dense_encoder import DenseEncoder
from schema_rag.embeddings.sparse_encoder import SparseEncoder
from schema_rag.llm.sql_generator import generate_sql
from schema_rag.retrieval.prompt_builder import build_sql_prompt
from schema_rag.retrieval.retriever import SchemaRetriever


def main() -> None:
    if len(sys.argv) < 2:
        print("Usage: python -m schema_rag.scripts.query \"your question here\"")
        sys.exit(1)

    question = sys.argv[1]
    print(f"Question: {question}")

    # Initialize components
    qdrant = QdrantClient(url=QDRANT_URL)
    dense_enc = DenseEncoder()
    sparse_enc = SparseEncoder()

    retriever = SchemaRetriever(qdrant, dense_enc, sparse_enc)

    # Retrieve
    result = retriever.retrieve(question)

    print(f"\nSeed tables: {result['seed_tables']}", file=sys.stderr)
    print(f"Expanded tables: {result['expanded_tables']}", file=sys.stderr)

    # Build prompt and generate SQL
    prompt = build_sql_prompt(question, result["ddl_context"])
    sql = generate_sql(prompt)

    print(f"\n--- Generated SQL ---")
    print(sql)


if __name__ == "__main__":
    main()
