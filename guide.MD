# Fina Berry — Docker Deployment Guide

## Port Mapping (tidak bentrok dengan Tomodachi)

| Project | Container | Host Port | Keterangan |
|---|---|---|---|
| Tomodachi | `tomodachi_nginx` | **80** | HTTP utama Tomodachi |
| **Fina Berry** | `finaberry_app` | **8081** | Laravel + nginx (internal) |
| **Fina Berry** | `finaberry_phpmyadmin` | **8082** | phpMyAdmin (opsional) |
| Fina Berry | `finaberry_db` | *(internal only)* | MySQL tidak expose ke host |

> [!IMPORTANT]
> Semua container Fina Berry ada di network `finaberry_net` (terpisah dari `tomodachi_net`). Tidak ada shared resource antar proyek.

---

## File yang Dibuat / Diubah

| File | Status | Keterangan |
|---|---|---|
| [docker-compose.prod.yml](file:///d:/laragon/www/fina_berry/Backend/docker-compose.prod.yml) | ✅ Updated | Port 8081/8082, named volumes `finaberry_*` |
| [.env.docker.example](file:///d:/laragon/www/fina_berry/Backend/.env.docker.example) | ✅ Baru | Template env untuk VPS |
| [docker-build-push.sh](file:///d:/laragon/www/fina_berry/Backend/docker-build-push.sh) | ✅ Baru | Build & push image ke Docker Hub |
| [docker-deploy-vps.sh](file:///d:/laragon/www/fina_berry/Backend/docker-deploy-vps.sh) | ✅ Updated | Deploy di VPS via `docker compose pull` |
| [Makefile](file:///d:/laragon/www/fina_berry/Backend/Makefile) | ✅ Baru | Shortcut semua perintah Docker |
| [Dockerfile](file:///d:/laragon/www/fina_berry/Backend/Dockerfile) | ✅ Updated | PHP versi diperbaiki ke 8.3 (sesuai composer.json) |
| [.dockerignore](file:///d:/laragon/www/fina_berry/Backend/.dockerignore) | ✅ Baru | Exclude .env, logs, tests dari image |

---

## Workflow: Lokal → Docker Hub → VPS

### 1. Setup awal (sekali saja)

Login ke Docker Hub:
```bash
docker login
```

### 2. Build & Push (dari lokal / CI)

```bash
cd fina_berry/Backend

# Build + push dengan tag versi
./docker-build-push.sh v1.0.0

# atau pakai make:
make push IMAGE_TAG=v1.0.0
```

### 3. Setup VPS (sekali saja)

```bash
# SSH ke VPS, lalu clone repo
git clone https://github.com/namauser/fina_berry.git ~/fina_berry
cd ~/fina_berry/Backend

# Buat file .env dari template
cp .env.docker.example .env
nano .env          # isi semua nilai yang kosong!

chmod +x docker-deploy-vps.sh docker-build-push.sh
```

### 4. Deploy / Update (di VPS)

```bash
cd ~/fina_berry/Backend

# Pull image terbaru + restart
./docker-deploy-vps.sh

# atau
make deploy
```

---

## Nginx Reverse Proxy di VPS

Tambahkan konfigurasi ini ke Nginx VPS (di `/etc/nginx/sites-available/finnaberry.conf`):

```nginx
server {
    listen 80;
    server_name www.finnaberry.my.id finnaberry.my.id;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl;
    server_name www.finnaberry.my.id finnaberry.my.id;

    # SSL (pakai certbot/let's encrypt)
    ssl_certificate     /etc/letsencrypt/live/www.finnaberry.my.id/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.finnaberry.my.id/privkey.pem;

    client_max_body_size 50M;

    location / {
        proxy_pass         http://127.0.0.1:8081;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 300;
    }
}
```

Aktifkan:
```bash
sudo ln -s /etc/nginx/sites-available/finnaberry.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# SSL via certbot
sudo certbot --nginx -d www.finnaberry.my.id -d finnaberry.my.id
```

---

## Checklist .env VPS

```env
DOCKER_IMAGE=finaberry/backend   # sesuai akun Docker Hub
IMAGE_TAG=latest
APP_URL=https://www.finnaberry.my.id
APP_KEY=base64:...               # generate: php artisan key:generate --show
APP_PORT=8081
PMA_PORT=8082
DB_DATABASE=finaberry
DB_USERNAME=finaberry_user
DB_PASSWORD=<password kuat>
DB_ROOT_PASSWORD=<root password kuat>
MIDTRANS_MERCHANT_ID=...
MIDTRANS_CLIENT_KEY=...
MIDTRANS_SERVER_KEY=...
MIDTRANS_IS_PRODUCTION=true
```

> [!WARNING]
> Jangan commit `.env` ke repository! File `.gitignore` sudah mengecualikannya.

---

## Perintah Berguna (Makefile)

```bash
make logs-app    # lihat log aplikasi real-time
make migrate     # jalankan migrasi database
make shell       # masuk ke shell container app
make db-shell    # masuk ke MySQL
make cache       # rebuild config/route/view cache
make backup-db   # backup database ke ./backups/
make ps          # cek status semua container
```
