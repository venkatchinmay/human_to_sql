"""Tests for SchemaRetriever — mocked Qdrant client."""

from __future__ import annotations

from typing import Any
from unittest.mock import MagicMock, patch

import pytest

from schema_rag.retrieval.retriever import SchemaRetriever


# ---------------------------------------------------------------------------
# Helpers / mocks
# ---------------------------------------------------------------------------

def _mock_point(table_name: str, score: float = 0.9) -> MagicMock:
    """Create a mock Qdrant ScoredPoint."""
    point = MagicMock()
    point.payload = {
        "table_name": table_name,
        "ddl": f"CREATE TABLE {table_name} (id INT);",
        "doc_text": f"table: {table_name}",
        "columns": ["id"],
        "fk_edges": [],
    }
    point.score = score
    point.id = table_name
    point.version = 0
    return point


def _mock_dense_encoder() -> MagicMock:
    enc = MagicMock()
    enc.encode_query.return_value = [0.1] * 384
    return enc


def _mock_sparse_encoder() -> MagicMock:
    enc = MagicMock()
    enc.encode.return_value = {"indices": [1, 5, 10], "values": [0.5, 0.3, 0.8]}
    return enc


def _mock_qdrant_client(
    search_results: list[MagicMock] | None = None,
    scroll_results: list[MagicMock] | None = None,
) -> MagicMock:
    client = MagicMock()

    # Mock query_points (hybrid search)
    mock_query_result = MagicMock()
    mock_query_result.points = search_results or []
    client.query_points.return_value = mock_query_result

    # Mock scroll (for expanded tables)
    client.scroll.return_value = (scroll_results or [], None)
    return client


# ---------------------------------------------------------------------------
# Tests
# ---------------------------------------------------------------------------

class TestSchemaRetriever:

    @patch("schema_rag.retrieval.retriever.load_fk_graph", return_value=None)
    def test_retrieve_seed_only_no_fk_graph(self, mock_load: MagicMock) -> None:
        """When FK graph is missing, only seed tables are returned."""
        mock_results = [_mock_point("orders"), _mock_point("products")]
        client = _mock_qdrant_client(search_results=mock_results)
        dense = _mock_dense_encoder()
        sparse = _mock_sparse_encoder()

        retriever = SchemaRetriever(client, dense, sparse)
        result = retriever.retrieve("show me orders")

        assert "orders" in result["seed_tables"]
        assert "products" in result["seed_tables"]
        # No FK expansion when graph is None
        assert result["expanded_tables"] == ["orders", "products"]

    @patch("schema_rag.retrieval.retriever.load_fk_graph")
    def test_hybrid_query_uses_prefetch_and_rrf(self, mock_load: MagicMock) -> None:
        """Verify hybrid search calls query_points with Prefetch + RRF Fusion."""
        import networkx as nx

        # Build a small FK graph: orders → users
        G = nx.DiGraph()
        G.add_edge("orders", "users")
        mock_load.return_value = G

        mock_results = [_mock_point("orders")]
        client = _mock_qdrant_client(search_results=mock_results)

        # scroll should return the users payload for FK expansion
        users_point = MagicMock()
        users_point.payload = {
            "table_name": "users",
            "ddl": "CREATE TABLE users (id INT);",
            "doc_text": "table: users",
            "columns": ["id"],
            "fk_edges": [],
        }
        users_point.id = "users"
        users_point.version = 0
        client.scroll.return_value = ([users_point], None)

        dense = _mock_dense_encoder()
        sparse = _mock_sparse_encoder()

        retriever = SchemaRetriever(client, dense, sparse)
        result = retriever.retrieve("show me orders")

        # Verify query_points was called (hybrid search)
        client.query_points.assert_called_once()

        # Check call args contain Prefetch and FusionQuery
        call_kwargs = client.query_points.call_args
        assert call_kwargs is not None

        # Verify expanded tables include users (FK-linked)
        assert "users" in result["expanded_tables"]
        assert "users" in result["seed_tables"] or any(
            p["table_name"] == "users" for p in result["payloads"]
        )

    @patch("schema_rag.retrieval.retriever.load_fk_graph", return_value=None)
    def test_dense_and_sparse_encode_called(self, mock_load: MagicMock) -> None:
        """Both encoders should be called for the question."""
        client = _mock_qdrant_client(search_results=[_mock_point("users")])
        dense = _mock_dense_encoder()
        sparse = _mock_sparse_encoder()

        retriever = SchemaRetriever(client, dense, sparse)
        retriever.retrieve("list all users")

        dense.encode_query.assert_called_once_with("list all users")
        sparse.encode.assert_called_once_with("list all users")
