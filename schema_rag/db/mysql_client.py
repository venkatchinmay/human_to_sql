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


def get_connection(database: str | None = None) -> MySQLConnection:
    """Create and return a MySQL connection using config values."""
    db_name = database or MYSQL_DATABASE
    conn = mysql.connector.connect(
        host=MYSQL_HOST,
        port=MYSQL_PORT,
        user=MYSQL_USER,
        password=MYSQL_PASSWORD,
        database=db_name,
    )
    logger.info("Connected to MySQL %s@%s:%s/%s", MYSQL_USER, MYSQL_HOST, MYSQL_PORT, db_name)
    return conn


# ---------------------------------------------------------------------------
# Introspection queries
# ---------------------------------------------------------------------------

_COLUMNS_SQL = """
SELECT
    TABLE_NAME, COLUMN_NAME, DATA_TYPE, COLUMN_TYPE,
    COLUMN_KEY, IS_NULLABLE, COLUMN_COMMENT, EXTRA
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = %s
ORDER BY TABLE_NAME, ORDINAL_POSITION;
"""

_TABLES_SQL = """
SELECT TABLE_NAME, TABLE_TYPE, TABLE_COMMENT
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = %s;
"""

_INDEXES_SQL = """
SELECT TABLE_NAME, INDEX_NAME, NON_UNIQUE, INDEX_TYPE, COLUMN_NAME
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = %s
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;
"""

_VIEWS_SQL = """
SELECT TABLE_NAME, VIEW_DEFINITION
FROM information_schema.VIEWS
WHERE TABLE_SCHEMA = %s;
"""

_FKS_SQL = """
SELECT
    TABLE_NAME, COLUMN_NAME,
    REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = %s
  AND REFERENCED_TABLE_NAME IS NOT NULL;
"""


def fetch_tables(conn: MySQLConnection, database: str | None = None) -> dict[str, dict[str, Any]]:
    """Return schema metadata per table/view for the target database."""
    db_name = database or MYSQL_DATABASE
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(_COLUMNS_SQL, (db_name,))
        rows = cursor.fetchall()

        tables: dict[str, dict[str, Any]] = {}
        for row in rows:
            tname = row["TABLE_NAME"]
            if tname not in tables:
                tables[tname] = {
                    "columns": [],
                    "comment": "",
                    "table_type": "BASE TABLE",
                    "indexes": [],
                    "view_definition": "",
                }
            tables[tname]["columns"].append({
                "name": row["COLUMN_NAME"],
                "type": row.get("COLUMN_TYPE") or row["DATA_TYPE"],
                "data_type": row["DATA_TYPE"],
                "key": row["COLUMN_KEY"],
                "nullable": row["IS_NULLABLE"] == "YES",
                "comment": row["COLUMN_COMMENT"] or "",
                "extra": row.get("EXTRA") or "",
            })

        # Fetch table types and comments
        cursor.execute(_TABLES_SQL, (db_name,))
        for row in cursor.fetchall():
            tname = row["TABLE_NAME"]
            if tname in tables:
                tables[tname]["table_type"] = row.get("TABLE_TYPE") or "BASE TABLE"
                tables[tname]["comment"] = row.get("TABLE_COMMENT") or ""

        # Fetch indexes (UNIQUE, FULLTEXT, secondary keys)
        cursor.execute(_INDEXES_SQL, (db_name,))
        grouped_indexes: dict[tuple[str, str], dict[str, Any]] = {}
        for row in cursor.fetchall():
            tname = row["TABLE_NAME"]
            iname = row["INDEX_NAME"]
            if tname not in tables:
                continue
            key = (tname, iname)
            if key not in grouped_indexes:
                grouped_indexes[key] = {
                    "name": iname,
                    "unique": row["NON_UNIQUE"] == 0,
                    "type": row.get("INDEX_TYPE") or "BTREE",
                    "columns": [],
                }
            grouped_indexes[key]["columns"].append(row["COLUMN_NAME"])

        for (tname, _), idx in grouped_indexes.items():
            tables[tname]["indexes"].append(idx)

        # Fetch view definitions
        cursor.execute(_VIEWS_SQL, (db_name,))
        for row in cursor.fetchall():
            tname = row["TABLE_NAME"]
            if tname in tables:
                tables[tname]["view_definition"] = row.get("VIEW_DEFINITION") or ""

        logger.info("Fetched %d tables/views from %s", len(tables), db_name)
        return tables
    finally:
        cursor.close()


def fetch_fk_edges(conn: MySQLConnection, database: str | None = None) -> dict[str, list[dict[str, str]]]:
    """Return ``{table_name: [{"column": ..., "ref_table": ..., "ref_column": ...}]}``."""
    db_name = database or MYSQL_DATABASE
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(_FKS_SQL, (db_name,))
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
