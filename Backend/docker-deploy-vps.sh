#!/bin/bash
# =============================================================
# docker-deploy-vps.sh — Deploy / Update Fina Berry di VPS
#
# SETUP AWAL (sekali saja dari lokal):
#   scp docker-compose.prod.yml .env.docker.example user@IP_VPS:~/finaberry/
#   ssh user@IP_VPS
#   cd ~/finaberry && cp .env.docker.example .env && nano .env
#
# UPDATE SELANJUTNYA (jalankan script ini di VPS):
#   cd ~/finaberry && ./docker-deploy-vps.sh
# =============================================================

set -e

COMPOSE_FILE="docker-compose.prod.yml"

echo "================================================================"
echo "  Fina Berry — Deploy via Docker Pull"
echo "================================================================"

# Pastikan docker-compose.prod.yml ada
if [ ! -f "$COMPOSE_FILE" ]; then
  echo ""
  echo "[!] $COMPOSE_FILE tidak ditemukan di direktori ini."
  echo ""
  echo "    Jalankan perintah ini dari LOKAL untuk copy file ke VPS:"
  echo "    scp docker-compose.prod.yml .env.docker.example user@IP_VPS:~/finaberry/"
  echo ""
  exit 1
fi

# Pastikan .env sudah ada
if [ ! -f ".env" ]; then
  echo ""
  echo "[!] File .env tidak ditemukan!"
  echo ""
  echo "    Buat .env dari template:"
  echo "    cp .env.docker.example .env && nano .env"
  echo ""
  exit 1
fi

echo ""
echo "[1/3] Pulling image terbaru dari Docker Hub..."
docker compose -f "$COMPOSE_FILE" pull

echo ""
echo "[2/3] Menjalankan containers..."
docker compose -f "$COMPOSE_FILE" up -d --remove-orphans

echo ""
echo "[3/3] Status containers:"
docker compose -f "$COMPOSE_FILE" ps

echo ""
echo "================================================================"
echo "  [OK] Deploy selesai!"
echo ""
echo "  App     : http://localhost:8081  (atau domain via reverse proxy)"
echo "  PMA     : http://localhost:8082  (jika diaktifkan)"
echo ""
echo "  Lihat logs  : docker compose -f $COMPOSE_FILE logs -f app"
echo "  Masuk shell : docker compose -f $COMPOSE_FILE exec app sh"
echo "================================================================"
