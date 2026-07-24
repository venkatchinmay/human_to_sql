"""MySQL client — schema introspection via information_schema."""

from __future__ import annotations

import logging
from typing import Any

import mysql.connector
from mysql.connector.connection import MySQLConnection

from schema_rag.config import MYSQL_DATABASE, MYSQL_HOST, MYSQL_PASSWORD, MYSQL_PORT, MYSQL_USER

logger = logging.getLogger(__name__)

# ---------------------------------------------------------------------------
# Connection
# ---------------------------------------------------------------------------


def get_connection() -> MySQLConnection:
    """Create and return a MySQL connection using config values."""
    conn = mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=MYSQL_DATABASE,
    )
    logger.info("Connected to MySQL %s@%s:%s/%s", MYSQL_USER, MYSQL_HOST, MYSQL_PORT, MYSQL_DATABASE)
    return conn


# ---------------------------------------------------------------------------
# Introspection queries
# ---------------------------------------------------------------------------

_COLUMNS_SQL = """
SELECT
    TABLE_NAME, COLUMN_NAME, DATA_TYPE,
    COLUMN_KEY, IS_NULLABLE, COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = %s
ORDER BY TABLE_NAME, ORDINAL_POSITION;
"""

_FKS_SQL = """
SELECT
    TABLE_NAME, COLUMN_NAME,
    REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = %s
  AND REFERENCED_TABLE_NAME IS NOT NULL;
"""


def fetch_tables(conn: MySQLConnection) -> dict[str, dict[str, Any]]:
    """Return ``{table_name: {"columns": [...], "comment": ...}}`` for every table."""
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(_COLUMNS_SQL, (MYSQL_DATABASE,))
        rows = cursor.fetchall()

        tables: dict[str, dict[str, Any]] = {}
        for row in rows:
            tname = row["TABLE_NAME"]
            if tname not in tables:
                tables[tname] = {"columns": [], "comment": ""}
            tables[tname]["columns"].append({
                "name": row["COLUMN_NAME"],
                "type": row["DATA_TYPE"],
                "key": row["COLUMN_KEY"],
                "nullable": row["IS_NULLABLE"] == "YES",
                "comment": row["COLUMN_COMMENT"] or "",
            })

        # Fetch table comments separately
        cursor.execute(
            "SELECT TABLE_NAME, TABLE_COMMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = %s",
            (MYSQL_DATABASE,),
        )
        for row in cursor.fetchall():
            if row["TABLE_NAME"] in tables:
                tables[row["TABLE_NAME"]]["comment"] = row["TABLE_COMMENT"] or ""

        logger.info("Fetched %d tables from %s", len(tables), MYSQL_DATABASE)
        return tables
    finally:
        cursor.close()


def fetch_fk_edges(conn: MySQLConnection) -> dict[str, list[dict[str, str]]]:
    """Return ``{table_name: [{"column": ..., "ref_table": ..., "ref_column": ...}]}``."""
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(_FKS_SQL, (MYSQL_DATABASE,))
        rows = cursor.fetchall()

        fk_map: dict[str, list[dict[str, str]]] = {}
        for row in rows:
            tname = row["TABLE_NAME"]
            edge = {
                "column": row["COLUMN_NAME"],
                "ref_table": row["REFERENCED_TABLE_NAME"],
                "ref_column": row["REFERENCED_COLUMN_NAME"],
            }
            fk_map.setdefault(tname, []).append(edge)

        total_edges = sum(len(v) for v in fk_map.values())
        logger.info("Fetched %d FK edges across %d tables", total_edges, len(fk_map))
        return fk_map
    finally:
        cursor.close()
