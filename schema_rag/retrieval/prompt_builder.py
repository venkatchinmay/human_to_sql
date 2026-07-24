"""Prompt builder — assembles the final LLM prompt from retrieved schema DDL."""

from __future__ import annotations

SQL_PROMPT_TEMPLATE = """\
You are an expert MySQL developer. Given the following database schema and a
natural-language question, generate a single SQL query that answers it.

## Schema

```sql
{ddl_context}
```

## Rules

1. Use ONLY the tables and columns provided in the schema above.
2. Alias tables when joining (e.g., `orders o JOIN users u ON ...`).
3. Use the foreign-key relationships shown in the schema for joins.
4. Return ONLY the SQL statement — no explanation, no markdown fences.
5. Use MySQL-compatible syntax.
6. If the question cannot be answered with the given schema, return an empty string.

## Question

{question}

## SQL
"""


def build_sql_prompt(question: str, ddl_context: str) -> str:
    """Build the LLM prompt from the question and retrieved DDL context."""
    return SQL_PROMPT_TEMPLATE.format(ddl_context=ddl_context, question=question)
