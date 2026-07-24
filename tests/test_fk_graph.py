"""Tests for FK graph construction and expansion."""

from __future__ import annotations

import json
import tempfile
from pathlib import Path

import networkx as nx
import pytest

from schema_rag.db.fk_graph import build_fk_graph, expand_via_fk, load_fk_graph, save_fk_graph


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

def _sample_fk_map() -> dict[str, list[dict[str, str]]]:
    """FK map matching the sample_schema.sql fixture."""
    return {
        "orders": [
            {"column": "user_id", "ref_table": "users", "ref_column": "id"},
        ],
        "order_items": [
            {"column": "order_id", "ref_table": "orders", "ref_column": "id"},
            {"column": "product_id", "ref_table": "products", "ref_column": "id"},
        ],
    }


@pytest.fixture()
def sample_graph() -> nx.DiGraph:
    return build_fk_graph(_sample_fk_map())


# ---------------------------------------------------------------------------
# build_fk_graph
# ---------------------------------------------------------------------------

class TestBuildFkGraph:

    def test_nodes_and_edges(self, sample_graph: nx.DiGraph) -> None:
        # All 4 tables should be nodes
        assert set(sample_graph.nodes()) == {"users", "orders", "products", "order_items"}
        # 3 FK edges
        assert sample_graph.number_of_edges() == 3

    def test_edge_direction(self, sample_graph: nx.DiGraph) -> None:
        # orders → users (orders has FK to users)
        assert sample_graph.has_edge("orders", "users")
        # order_items → orders, order_items → products
        assert sample_graph.has_edge("order_items", "orders")
        assert sample_graph.has_edge("order_items", "products")


# ---------------------------------------------------------------------------
# save / load round-trip
# ---------------------------------------------------------------------------

class TestPersistence:

    def test_round_trip(self, sample_graph: nx.DiGraph, tmp_path: Path) -> None:
        path = tmp_path / "fk_graph.json"
        save_fk_graph(sample_graph, path)
        assert path.exists()

        loaded = load_fk_graph(path)
        assert loaded is not None
        assert set(loaded.nodes()) == set(sample_graph.nodes())
        assert set(loaded.edges()) == set(sample_graph.edges())

    def test_load_missing_returns_none(self, tmp_path: Path) -> None:
        result = load_fk_graph(tmp_path / "nonexistent.json")
        assert result is None


# ---------------------------------------------------------------------------
# expand_via_fk
# ---------------------------------------------------------------------------

class TestExpandViaFk:

    def test_depth_1_from_orders(self, sample_graph: nx.DiGraph) -> None:
        # orders → users (successor), order_items → orders (predecessor)
        result = expand_via_fk({"orders"}, sample_graph, depth=1)
        assert result == {"orders", "users", "order_items"}

    def test_depth_1_from_users(self, sample_graph: nx.DiGraph) -> None:
        # users has no outgoing edges, but orders → users (predecessor)
        result = expand_via_fk({"users"}, sample_graph, depth=1)
        assert result == {"users", "orders"}

    def test_depth_2_from_users(self, sample_graph: nx.DiGraph) -> None:
        # users ←(depth 1) orders ←(depth 2) order_items
        # products requires depth 3 (order_items → products)
        result = expand_via_fk({"users"}, sample_graph, depth=2)
        assert result == {"users", "orders", "order_items"}

    def test_depth_3_from_users(self, sample_graph: nx.DiGraph) -> None:
        # Full graph reachable at depth 3
        result = expand_via_fk({"users"}, sample_graph, depth=3)
        assert result == {"users", "orders", "order_items", "products"}

    def test_isolated_table(self) -> None:
        # Table with no FKs at all
        G = nx.DiGraph()
        G.add_node("lonely_table")
        result = expand_via_fk({"lonely_table"}, G, depth=1)
        assert result == {"lonely_table"}

    def test_empty_seed(self, sample_graph: nx.DiGraph) -> None:
        result = expand_via_fk(set(), sample_graph, depth=1)
        assert result == set()
