#!/bin/sh
set -e

echo "=== Fina Berry Production Startup ==="

# 1. Generate APP_KEY jika belum ada
if [ -z "$APP_KEY" ]; then
    echo "[!] APP_KEY tidak ditemukan di environment. Generate dulu di lokal lalu set di .env VPS!"
    exit 1
fi

# 2. Tunggu MySQL siap
echo "[*] Menunggu koneksi database..."
until php artisan db:monitor --databases=mysql 2>/dev/null; do
    sleep 2
    echo "    ... menunggu database ..."
done 2>/dev/null || true

# Fallback jika db:monitor tidak ada
MAX_RETRIES=30
COUNT=0
until php -r "
    try {
        new PDO('mysql:host=' . getenv('DB_HOST') . ';port=' . getenv('DB_PORT') . ';dbname=' . getenv('DB_DATABASE'),
                getenv('DB_USERNAME'), getenv('DB_PASSWORD'));
        echo 'ok';
    } catch (Exception \$e) {
        exit(1);
    }
" 2>/dev/null; do
    COUNT=$((COUNT+1))
    if [ $COUNT -ge $MAX_RETRIES ]; then
        echo "[!] Database tidak bisa dihubungi setelah $MAX_RETRIES percobaan. Lanjut..."
        break
    fi
    echo "    ... menunggu DB ($COUNT/$MAX_RETRIES) ..."
    sleep 3
done

echo "[✓] Database siap!"

# 3. Jalankan migrasi
echo "[*] Menjalankan migrasi database..."
php artisan migrate --force --no-interaction

# 4. Optimasi Laravel (cache config, routes, views)
echo "[*] Mengoptimasi Laravel..."
php artisan config:cache
php artisan route:cache
php artisan view:cache
php artisan event:cache

# 5. Storage link
echo "[*] Membuat storage link..."
php artisan storage:link || true

# 6. Set permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo "[✓] Startup selesai. Menjalankan services..."

# 7. Jalankan supervisor (nginx + php-fpm + queue)
exec /usr/bin/supervisord -c /etc/supervisord.conf
