"""FK graph — build, persist, load, and expand a foreign-key relationship graph."""

from __future__ import annotations

import json
import logging
from pathlib import Path
from typing import Any

import networkx as nx

logger = logging.getLogger(__name__)


def build_fk_graph(fk_map: dict[str, list[dict[str, str]]]) -> nx.DiGraph:
    """Build a directed graph from the FK map.

    Nodes are table names.  An edge ``table_a → table_b`` means *table_a*
    has a foreign key referencing *table_b*.
    """
    G = nx.DiGraph()
    for table, edges in fk_map.items():
        G.add_node(table)
        for edge in edges:
            ref_table = edge["ref_table"]
            G.add_node(ref_table)
            G.add_edge(table, ref_table, column=edge["column"], ref_column=edge["ref_column"])
    logger.info("Built FK graph: %d nodes, %d edges", G.number_of_nodes(), G.number_of_edges())
    return G


def save_fk_graph(G: nx.DiGraph, path: Path) -> None:
    """Persist the graph to a JSON file via node-link data."""
    data = nx.node_link_data(G)
    path.write_text(json.dumps(data, indent=2))
    logger.info("Saved FK graph to %s (%d nodes)", path, G.number_of_nodes())


def load_fk_graph(path: Path) -> nx.DiGraph | None:
    """Load the graph from a JSON file.  Returns *None* if file is missing."""
    if not path.exists():
        logger.warning("FK graph file not found at %s — FK expansion disabled", path)
        return None
    data = json.loads(path.read_text())
    G = nx.node_link_graph(data)  # type: ignore[arg-type]  # networkx returns DiGraph when directed=True in data
    logger.info("Loaded FK graph from %s (%d nodes)", path, G.number_of_nodes())
    return G


def expand_via_fk(seed_tables: set[str], G: nx.DiGraph, depth: int = 1) -> set[str]:
    """Expand *seed_tables* along FK edges (bidirectionally) up to *depth* hops.

    Returns the union of seed tables and all discovered neighbours.
    """
    expanded: set[str] = set(seed_tables)
    current_frontier: set[str] = set(seed_tables)

    for _hop in range(depth):
        next_frontier: set[str] = set()
        for table in current_frontier:
            if table not in G:
                continue
            # Successors: tables this one references (outgoing edges)
            for succ in G.successors(table):
                if succ not in expanded:
                    next_frontier.add(succ)
            # Predecessors: tables that reference this one (incoming edges)
            for pred in G.predecessors(table):
                if pred not in expanded:
                    next_frontier.add(pred)
        expanded.update(next_frontier)
        current_frontier = next_frontier

    new_tables = expanded - set(seed_tables)
    if new_tables:
        logger.info("FK expansion added %d tables: %s", len(new_tables), new_tables)
    return expanded
