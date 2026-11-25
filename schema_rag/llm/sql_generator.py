"""SQL generator — calls Ollama to produce SQL from a prompt."""

from __future__ import annotations

import logging
import re

import httpx

from schema_rag.config import OLLAMA_MODEL, OLLAMA_URL

logger = logging.getLogger(__name__)

# Models known to require chat completions
_CHAT_MODELS = {"gemma3:1b", "gemma3:4b", "gemma3:12b", "gemma3:27b"}

# Allowed leading keywords for read-only queries
_READ_ONLY_PREFIXES = ("select", "with", "show", "explain")
_FORBIDDEN_KEYWORDS = re.compile(
    r"\b(?:insert|update|delete|drop|alter|truncate|create|replace|grant|revoke|call|lock|unlock)\b",
    re.IGNORECASE,
)


def _strip_markdown(sql: str) -> str:
    """Remove markdown code fences, optional leading labels, and surrounding whitespace."""
    sql = sql.strip()
    # Extract fenced block if the model included prose before/after fences
    fence_match = re.search(r"```(?:sql)?\s*\n?(.*?)\n?```", sql, flags=re.DOTALL | re.IGNORECASE)
    if fence_match:
        sql = fence_match.group(1)
    sql = re.sub(r"^(?:sql|query)\s*:\s*", "", sql.strip(), flags=re.IGNORECASE)
    return sql.strip()


def _strip_sql_comments(sql: str) -> str:
    """Remove leading/inline SQL comments to inspect statement verbs safely."""
    no_block = re.sub(r"/\*.*?\*/", " ", sql, flags=re.DOTALL)
    no_line = re.sub(r"--[^\n]*", " ", no_block)
    return no_line.strip()


def sanitize_read_only_sql(sql: str) -> str:
    """Clean model output and enforce single-statement read-only SQL.

    Returns ``""`` when the model refuses, returns ``NULL``/empty, or outputs a
    non-read-only / multi-statement query.
    """
    cleaned = _strip_markdown(sql)
    if not cleaned or cleaned.upper() == "NULL":
        return ""

    stripped = _strip_sql_comments(cleaned)
    if not stripped:
        return ""

    # Reject multi-statement payloads (ignoring a single trailing semicolon)
    body_without_trailing_semi = stripped.rstrip(";").strip()
    if ";" in body_without_trailing_semi:
        logger.warning("Rejected multi-statement SQL output.")
        return ""

    first_word = body_without_trailing_semi.split(None, 1)[0].lower()
    if first_word not in _READ_ONLY_PREFIXES:
        logger.warning("Rejected non-read-only SQL starting with %r", first_word)
        return ""

    if _FORBIDDEN_KEYWORDS.search(body_without_trailing_semi):
        # Allow legitimate column/table names only if they aren't statement verbs?
        # Wait: columns like `created_at` or `update_time` won't match \bcreate\b or \bupdate\b,
        # but `order_status` etc. won't either. Still, check statement verbs outside quotes!
        unquoted = re.sub(r"'[^']*'|\"[^\"]*\"|`[^`]*`", " ", body_without_trailing_semi)
        if _FORBIDDEN_KEYWORDS.search(unquoted):
            logger.warning("Rejected SQL containing mutating/DDL keyword.")
            return ""

    return cleaned


def generate_sql(
    prompt: str,
    model: str | None = None,
    ollama_url: str | None = None,
    read_only: bool = True,
) -> str:
    """Generate SQL by calling Ollama.

    This function is the single abstraction point for LLM interaction,
    making it easy to swap backends later.
    """
    _model = model or OLLAMA_MODEL
    _url = (ollama_url or OLLAMA_URL).rstrip("/")

    logger.info("Calling Ollama model=%s at %s", _model, _url)

    if _model in _CHAT_MODELS or _model.startswith("gemma3"):
        endpoint = f"{_url}/api/chat"
        payload = {
            "model": _model,
            "messages": [{"role": "user", "content": prompt}],
            "stream": False,
            "options": {"temperature": 0},
        }
    else:
        endpoint = f"{_url}/api/generate"
        payload = {
            "model": _model,
            "prompt": prompt,
            "stream": False,
            "options": {"temperature": 0},
        }

    resp = httpx.post(endpoint, json=payload, timeout=300.0)
    resp.raise_for_status()
    if not resp.content:
        raise RuntimeError(f"Empty response body from Ollama ({endpoint})")
    data = resp.json()

    # Extract response text depending on endpoint
    if "message" in data and isinstance(data["message"], dict):
        raw_sql = data["message"].get("content", "")
    else:
        raw_sql = data.get("response", "")

    sql = sanitize_read_only_sql(raw_sql) if read_only else _strip_markdown(raw_sql)
    logger.info("Generated SQL (%d chars): %s", len(sql), sql[:200])
    return sql
