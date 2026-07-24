"""Sparse encoder — wraps naver/splade-v3-small via HuggingFace transformers."""

from __future__ import annotations

import logging
from typing import Any

import torch
from transformers import AutoModelForMaskedLM, AutoTokenizer

from schema_rag.config import SPARSE_MODEL

logger = logging.getLogger(__name__)


class SparseEncoder:
    """Produces BM25-style sparse vectors using SPLADE pooling."""

    def __init__(self, model_name: str = SPARSE_MODEL) -> None:
        logger.info("Loading sparse encoder model: %s (CPU)", model_name)
        self._tokenizer = AutoTokenizer.from_pretrained(model_name)
        self._model = AutoModelForMaskedLM.from_pretrained(model_name)
        self._model.eval()
        logger.info("Sparse encoder loaded.")

    # ------------------------------------------------------------------
    # Public API
    # ------------------------------------------------------------------

    def encode(self, text: str) -> dict[str, Any]:
        """Encode *text* into a sparse vector dict ``{"indices": [...], "values": [...]}``.

        Aggregation: ``log(1 + relu(logits))``, max-pooled over the sequence.
        """
        inputs = self._tokenizer(text, return_tensors="pt", truncation=True, max_length=512)
        with torch.no_grad():
            logits = self._model(**inputs).logits  # (1, seq_len, vocab_size)

        # ReLU → log → max-pool over sequence dim
        values, _ = torch.max(torch.log1p(torch.relu(logits)), dim=1)  # (1, vocab_size)

        # Convert to sparse representation (drop zeros)
        sparse_values = values.squeeze().tolist()
        indices = [i for i, v in enumerate(sparse_values) if v > 0]
        values = [sparse_values[i] for i in indices]

        return {"indices": indices, "values": values}
