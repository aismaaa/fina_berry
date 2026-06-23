#!/bin/bash
# =============================================================
# docker-build-push.sh — Build & push image Fina Berry ke Docker Hub
# Jalankan dari: fina_berry/Backend/
# Usage: ./docker-build-push.sh [IMAGE_TAG]
# =============================================================

set -e

DOCKER_IMAGE="${DOCKER_IMAGE:-finaberry/backend}"
IMAGE_TAG="${1:-latest}"
FULL_IMAGE="${DOCKER_IMAGE}:${IMAGE_TAG}"

echo "================================================================"
echo "  Fina Berry — Build & Push Docker Image"
echo "  Image : $FULL_IMAGE"
echo "================================================================"

echo ""
echo "[1/3] Building image..."
docker build \
  --platform linux/amd64 \
  -t "${FULL_IMAGE}" \
  -f Dockerfile \
  .

echo ""
echo "[2/3] Tagging as latest..."
if [ "$IMAGE_TAG" != "latest" ]; then
  docker tag "${FULL_IMAGE}" "${DOCKER_IMAGE}:latest"
fi

echo ""
echo "[3/3] Pushing ke Docker Hub..."
docker push "${FULL_IMAGE}"
if [ "$IMAGE_TAG" != "latest" ]; then
  docker push "${DOCKER_IMAGE}:latest"
fi

echo ""
echo "================================================================"
echo "  [✓] Image berhasil di-push: $FULL_IMAGE"
echo "  Sekarang jalankan di VPS:"
echo "    docker compose -f docker-compose.prod.yml pull"
echo "    docker compose -f docker-compose.prod.yml up -d"
echo "================================================================"
