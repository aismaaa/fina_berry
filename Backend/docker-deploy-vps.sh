#!/bin/bash
# ============================================================
# Script Deploy di VPS (jalankan sekali setelah upload file)
# ============================================================

set -e

DOCKER_IMAGE="yourdockerhubusername/finaberry-app"
TAG="latest"

echo "=== Fina Berry VPS Deploy ==="

# 1. Pull image terbaru
echo "[1/3] Pulling image: $DOCKER_IMAGE:$TAG"
docker pull $DOCKER_IMAGE:$TAG

# 2. Stop container lama (jika ada)
echo "[2/3] Stopping container lama..."
docker-compose -f docker-compose.prod.yml down || true

# 3. Jalankan dengan image baru
echo "[3/3] Menjalankan container..."
docker-compose -f docker-compose.prod.yml up -d

echo ""
echo "=== Deploy Selesai! ==="
docker-compose -f docker-compose.prod.yml ps
