"""SQL generator — calls Ollama to produce SQL from a prompt."""

from __future__ import annotations

import logging
import re

import httpx

from schema_rag.config import OLLAMA_MODEL, OLLAMA_URL

logger = logging.getLogger(__name__)

# Models known to require chat completions
_CHAT_MODELS = {"gemma3:1b", "gemma3:4b", "gemma3:12b", "gemma3:27b"}


def _strip_markdown(sql: str) -> str:
    """Remove markdown code fences and surrounding whitespace."""
    sql = sql.strip()
    # Remove ```sql ... ``` or ``` ... ```
    sql = re.sub(r"^```(?:sql)?\s*\n?", "", sql)
    sql = re.sub(r"\n?```\s*$", "", sql)
    return sql.strip()


def generate_sql(prompt: str, model: str | None = None, ollama_url: str | None = None) -> str:
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
        }
    else:
        endpoint = f"{_url}/api/generate"
        payload = {
            "model": _model,
            "prompt": prompt,
            "stream": False,
        }

    resp = httpx.post(endpoint, json=payload, timeout=300.0)
    resp.raise_for_status()
    data = resp.json()

    # Extract response text depending on endpoint
    if "message" in data:
        raw_sql = data["message"]["content"]
    else:
        raw_sql = data.get("response", "")

    sql = _strip_markdown(raw_sql)
    logger.info("Generated SQL (%d chars): %s", len(sql), sql[:200])
    return sql
