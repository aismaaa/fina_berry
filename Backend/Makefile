## =============================================================
## Fina Berry — Makefile
## =============================================================

COMPOSE_FILE   = docker-compose.prod.yml
DOCKER_IMAGE  ?= finaberry/backend
IMAGE_TAG     ?= latest

.PHONY: help build push deploy up down logs ps shell db-shell migrate cache-clear

help: ## Tampilkan bantuan
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}'

# ── Build & Push ────────────────────────────────────────────
build: ## Build Docker image (linux/amd64)
	docker build --platform linux/amd64 \
		-t $(DOCKER_IMAGE):$(IMAGE_TAG) \
		-f Dockerfile .

push: build ## Build lalu push ke Docker Hub
	@if [ "$(IMAGE_TAG)" != "latest" ]; then \
		docker tag $(DOCKER_IMAGE):$(IMAGE_TAG) $(DOCKER_IMAGE):latest; \
	fi
	docker push $(DOCKER_IMAGE):$(IMAGE_TAG)
	@if [ "$(IMAGE_TAG)" != "latest" ]; then \
		docker push $(DOCKER_IMAGE):latest; \
	fi
	@echo "[OK] Image $(DOCKER_IMAGE):$(IMAGE_TAG) berhasil di-push"

# ── VPS ─────────────────────────────────────────────────────
deploy: ## Pull image terbaru lalu restart (jalankan di VPS)
	docker compose -f $(COMPOSE_FILE) pull
	docker compose -f $(COMPOSE_FILE) up -d --remove-orphans
	docker compose -f $(COMPOSE_FILE) ps

up: ## Jalankan semua container
	docker compose -f $(COMPOSE_FILE) up -d

down: ## Hentikan semua container
	docker compose -f $(COMPOSE_FILE) down

restart: ## Restart semua container
	docker compose -f $(COMPOSE_FILE) restart

ps: ## Status containers
	docker compose -f $(COMPOSE_FILE) ps

logs: ## Lihat logs (semua services)
	docker compose -f $(COMPOSE_FILE) logs -f

logs-app: ## Lihat logs app saja
	docker compose -f $(COMPOSE_FILE) logs -f app

# ── App ─────────────────────────────────────────────────────
shell: ## Masuk ke shell container app
	docker compose -f $(COMPOSE_FILE) exec app sh

db-shell: ## Masuk ke shell MySQL
	docker compose -f $(COMPOSE_FILE) exec db mysql \
		-u $${DB_USERNAME:-finaberry} \
		-p$${DB_PASSWORD} \
		$${DB_DATABASE:-finaberry}

migrate: ## Jalankan migrasi database
	docker compose -f $(COMPOSE_FILE) exec app php artisan migrate --force

cache-clear: ## Clear semua cache Laravel
	docker compose -f $(COMPOSE_FILE) exec app php artisan optimize:clear

cache: ## Rebuild Laravel cache (config/route/view)
	docker compose -f $(COMPOSE_FILE) exec app php artisan optimize

# ── Maintenance ─────────────────────────────────────────────
backup-db: ## Backup database ke ./backups/
	@mkdir -p backups
	docker compose -f $(COMPOSE_FILE) exec db sh -c \
		"mysqldump -u root -p$${DB_ROOT_PASSWORD} $${DB_DATABASE:-finaberry}" \
		> backups/finaberry_$$(date +%Y%m%d_%H%M%S).sql
	@echo "[OK] Backup tersimpan di backups/"
