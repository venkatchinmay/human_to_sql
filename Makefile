.PHONY: help install ingest query test docker-build docker-up docker-down helm-install helm-uninstall helm-upgrade clean

# ---------------------------------------------------------------------------
# Default
# ---------------------------------------------------------------------------
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------------
# Python setup
# ---------------------------------------------------------------------------
install: ## Install Python dependencies
	pip install -r requirements.txt

# ---------------------------------------------------------------------------
# CLI scripts
# ---------------------------------------------------------------------------
ingest: ## Run schema ingestion (MySQL → Qdrant)
	python -m schema_rag.scripts.ingest

query: ## Ask a question (usage: make query Q="your question")
	python -m schema_rag.scripts.query "$(Q)"

# ---------------------------------------------------------------------------
# API server
# ---------------------------------------------------------------------------
serve: ## Start the FastAPI server
	uvicorn schema_rag.api.app:app --host 0.0.0.0 --port 8000 --reload

# ---------------------------------------------------------------------------
# Testing
# ---------------------------------------------------------------------------
test: ## Run unit tests
	pytest tests/ -v

# ---------------------------------------------------------------------------
# Docker
# ---------------------------------------------------------------------------
docker-build: ## Build the application Docker image
	docker build -t schema-rag:latest .

docker-up: ## Start all services via docker-compose
	docker compose up -d

docker-down: ## Stop all docker-compose services
	docker compose down

docker-logs: ## Tail application logs
	docker compose logs -f app

# ---------------------------------------------------------------------------
# Helm / Kubernetes
# ---------------------------------------------------------------------------
helm-install: ## Install via Helm (default values)
	helm install schema-rag ./helm/schema-rag

helm-install-local: ## Install via Helm (minikube/local values)
	helm install schema-rag ./helm/schema-rag -f ./helm/schema-rag/values-local.yaml

helm-upgrade: ## Upgrade Helm release
	helm upgrade schema-rag ./helm/schema-rag

helm-uninstall: ## Uninstall Helm release
	helm uninstall schema-rag

helm-template: ## Render Helm templates (dry run)
	helm template schema-rag ./helm/schema-rag

# ---------------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------------
clean: ## Remove generated artifacts
	rm -f fk_graph.json
	rm -rf __pycache__ .pytest_cache .mypy_cache
	find . -name "*.pyc" -delete
