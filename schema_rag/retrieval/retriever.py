"""Hybrid retriever — dense + sparse search with RRF fusion and FK expansion."""

from __future__ import annotations

import logging
from typing import Any

import networkx as nx
from qdrant_client import QdrantClient
from qdrant_client.models import (
    FieldCondition,
    Filter,
    Fusion,
    FusionQuery,
    MatchAny,
    Prefetch,
    SparseVector,
)

from schema_rag.config import (
    FK_EXPAND_DEPTH,
    FK_GRAPH_PATH,
    QDRANT_COLLECTION,
    TOP_K_FINAL,
    TOP_K_RETRIEVAL,
)
from schema_rag.db.fk_graph import load_fk_graph
from schema_rag.embeddings.dense_encoder import DenseEncoder
from schema_rag.embeddings.sparse_encoder import SparseEncoder

logger = logging.getLogger(__name__)


class SchemaRetriever:
    """Orchestrates hybrid search, FK expansion, and context assembly."""

    def __init__(
        self,
        qdrant: QdrantClient,
        dense_enc: DenseEncoder,
        sparse_enc: SparseEncoder,
    ) -> None:
        self._client = qdrant
        self._dense_enc = dense_enc
        self._sparse_enc = sparse_enc

        # Load FK graph once (graceful degradation if missing)
        self._fk_graph: nx.DiGraph | None = load_fk_graph(FK_GRAPH_PATH)
        if self._fk_graph is not None:
            logger.info("FK graph loaded — expansion enabled (depth=%d)", FK_EXPAND_DEPTH)
        else:
            logger.warning("FK graph not available — retrieval will return seed tables only")

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def retrieve(self, question: str, top_k: int = TOP_K_FINAL) -> dict[str, Any]:
        """Retrieve relevant schema context for *question*.

        Returns ``{
            seed_tables: list[str],
            expanded_tables: list[str],
            ddl_context: str,
            payloads: list[dict],
        }``
        """
        # 1. Encode the question
        dense_vec = self._dense_enc.encode_query(question)
        sparse_data = self._sparse_enc.encode(question)
        sparse_vec = SparseVector(
            indices=sparse_data["indices"],
            values=sparse_data["values"],
        )

        # 2. Hybrid search via Qdrant (Prefetch dense + sparse → RRF fusion)
        prefetch_dense = Prefetch(
            query=dense_vec,
            using="dense",
            limit=TOP_K_RETRIEVAL,
        )
        prefetch_sparse = Prefetch(
            query=sparse_vec,
            using="sparse",
            limit=TOP_K_RETRIEVAL,
        )

        results = self._client.query_points(
            collection_name=QDRANT_COLLECTION,
            prefetch=[prefetch_dense, prefetch_sparse],
            query=FusionQuery(fusion=Fusion.RRF),
            limit=top_k,
            with_payload=True,
        ).points

        # 3. Extract seed table names
        seed_tables: list[str] = []
        seed_payloads: list[dict[str, Any]] = []
        for point in results:
            payload = dict(point.payload)  # type: ignore[arg-type]
            tname = payload["table_name"]
            seed_tables.append(tname)
            seed_payloads.append(payload)

        # 4. FK expansion
        expanded_tables: set[str] = set(seed_tables)
        if self._fk_graph is not None:
            expanded_tables = self._expand(seed_tables)

        # 5. Fetch payloads for expanded tables not in the seed set
        new_tables = expanded_tables - set(seed_tables)
        extra_payloads = self._fetch_payloads_by_tables(list(new_tables))
        all_payloads = seed_payloads + extra_payloads

        # 6. Assemble DDL context
        ddl_lines = [p["ddl"] for p in all_payloads]
        ddl_context = "\n\n".join(ddl_lines)

        logger.info(
            "Retrieval complete: seed=%s, expanded=%s",
            seed_tables,
            list(new_tables),
        )

        return {
            "seed_tables": seed_tables,
            "expanded_tables": list(expanded_tables),
            "ddl_context": ddl_context,
            "payloads": all_payloads,
        }

    # ------------------------------------------------------------------
    # Internal helpers
    # ------------------------------------------------------------------

    def _expand(self, seed_tables: list[str]) -> set[str]:
        """Expand seed tables through the FK graph."""
        from schema_rag.db.fk_graph import expand_via_fk

        return expand_via_fk(set(seed_tables), self._fk_graph, depth=FK_EXPAND_DEPTH)  # type: ignore[arg-type]

    def _fetch_payloads_by_tables(self, table_names: list[str]) -> list[dict[str, Any]]:
        """Scroll Qdrant for payloads of specific table names."""
        if not table_names:
            return []

        results, _ = self._client.scroll(
            collection_name=QDRANT_COLLECTION,
            scroll_filter=Filter(
                must=[
                    FieldCondition(
                        key="table_name",
                        match=MatchAny(any=table_names),
                    )
                ]
            ),
            limit=len(table_names),
            with_payload=True,
        )

        payloads: list[dict[str, Any]] = []
        for point in results:
            payloads.append(dict(point.payload))  # type: ignore[arg-type]
        return payloads
