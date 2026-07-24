"""Dense encoder — wraps BAAI/bge-small-en-v1.5 via FlagEmbedding."""

from __future__ import annotations

import logging

import numpy as np
from FlagEmbedding import FlagModel

from schema_rag.config import DENSE_MODEL

logger = logging.getLogger(__name__)

# BGE instruction prefix for queries (not for documents)
_QUERY_INSTRUCTION = "Represent this sentence for searching relevant passages: "


class DenseEncoder:
    """Singleton-friendly wrapper around a BGE embedding model (CPU-only)."""

    def __init__(self, model_name: str = DENSE_MODEL) -> None:
        logger.info("Loading dense encoder model: %s (CPU)", model_name)
        self._model = FlagModel(
            model_name,
            query_instruction_for_retrieval=_QUERY_INSTRUCTION,
            use_fp16=False,
        )
        logger.info("Dense encoder loaded.")

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def encode_doc(self, text: str | list[str]) -> list[float] | list[list[float]]:
        """Encode document text(s) without instruction prefix.

        Returns a list of floats for a single input, or a list of lists
        for multiple inputs.
        """
        embeddings = self._model.encode_corpus(text)  # type: ignore[arg-type]
        result = embeddings.tolist()
        return result

    def encode_query(self, text: str) -> list[float]:
        """Encode a query string with the BGE instruction prefix."""
        embedding = self._model.encode_queries([text])
        return embedding[0].tolist()
