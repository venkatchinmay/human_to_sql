"""Central configuration — all constants loaded from environment / .env."""

from __future__ import annotations

import os
from pathlib import Path

from dotenv import load_dotenv

# Load .env from project root (two levels up from this file)
_PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(_PROJECT_ROOT / ".env")

# ---------------------------------------------------------------------------
# MySQL
# ---------------------------------------------------------------------------
MYSQL_HOST: str = os.getenv("MYSQL_HOST", "localhost")
MYSQL_PORT: int = int(os.getenv("MYSQL_PORT", "3306"))
MYSQL_USER: str = os.getenv("MYSQL_USER", "root")
MYSQL_PASSWORD: str = os.getenv("MYSQL_PASSWORD", "")
MYSQL_DATABASE: str = os.getenv("MYSQL_DATABASE", "your_database")

# ---------------------------------------------------------------------------
# Qdrant
# ---------------------------------------------------------------------------
QDRANT_URL: str = os.getenv("QDRANT_URL", "http://localhost:6333")
QDRANT_COLLECTION: str = os.getenv("QDRANT_COLLECTION", "mysql_schema")

# ---------------------------------------------------------------------------
# Embedding models
# ---------------------------------------------------------------------------
DENSE_MODEL: str = os.getenv("DENSE_MODEL", "BAAI/bge-small-en-v1.5")
DENSE_DIM: int = 384
SPARSE_MODEL: str = os.getenv("SPARSE_MODEL", "prithivida/Splade_PP_en_v1")

# ---------------------------------------------------------------------------
# LLM (Ollama)
# ---------------------------------------------------------------------------
OLLAMA_URL: str = os.getenv("OLLAMA_URL", "http://localhost:11434")
OLLAMA_MODEL: str = os.getenv("OLLAMA_MODEL", "gemma2:2b")

# ---------------------------------------------------------------------------
# Retrieval tuning
# ---------------------------------------------------------------------------
FK_EXPAND_DEPTH: int = int(os.getenv("FK_EXPAND_DEPTH", "1"))
TOP_K_RETRIEVAL: int = int(os.getenv("TOP_K_RETRIEVAL", "10"))
TOP_K_FINAL: int = int(os.getenv("TOP_K_FINAL", "5"))
MAX_EXPANDED_TABLES: int = int(os.getenv("MAX_EXPANDED_TABLES", "12"))

# ---------------------------------------------------------------------------
# FK graph persistence
# ---------------------------------------------------------------------------
FK_GRAPH_PATH: Path = Path(os.getenv("FK_GRAPH_PATH", str(_PROJECT_ROOT / "fk_graph.json")))

# ---------------------------------------------------------------------------
# Application
# ---------------------------------------------------------------------------
APP_HOST: str = os.getenv("APP_HOST", "0.0.0.0")
APP_PORT: int = int(os.getenv("APP_PORT", "8000"))
LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
