# Fina Berry - API Deployment Guide

## 1. Pre-Deployment Checklist

### Backend Requirements
- PHP 8.3+
- MySQL 8.0+
- Composer
- Git

### Environment Setup
```bash
# Clone repository
git clone <repo-url> fina_berry
cd fina_berry/Backend

# Install dependencies
composer install --optimize-autoloader --no-dev

# Generate application key (already done)
php artisan key:generate

# Create production .env file
cp .env.example .env.production
```

## 2. Production Environment Configuration

Create `.env.production` with:
```env
APP_NAME="Fina Berry API"
APP_ENV=production
APP_KEY=base64:YOUR_APP_KEY_HERE
APP_DEBUG=false
APP_URL=https://api.yourdomain.com

DB_CONNECTION=mysql
DB_HOST=your-db-host
DB_PORT=3306
DB_DATABASE=fina_berry_prod
DB_USERNAME=db_user
DB_PASSWORD=strong_password

CACHE_DRIVER=redis
QUEUE_CONNECTION=database
SESSION_DRIVER=database
FILESYSTEM_DISK=public

MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=587
MAIL_USERNAME=your_username
MAIL_PASSWORD=your_password
```

## 3. Server Setup Steps

### Step 1: Database Migration
```bash
php artisan migrate --force
php artisan db:seed
```

### Step 2: Cache & Config
```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Step 3: Storage Permissions
```bash
chmod -R 775 storage/
chmod -R 775 bootstrap/cache/
```

### Step 4: SSL Certificate (Let's Encrypt)
```bash
# Using Certbot
sudo certbot certonly --webroot -w /path/to/public -d api.yourdomain.com
```

### Step 5: Nginx Configuration
```nginx
server {
    listen 443 ssl http2;
    server_name api.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/api.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.yourdomain.com/privkey.pem;

    root /var/www/fina_berry/Backend/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name api.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

### Step 6: PHP-FPM Configuration
Update `/etc/php/8.3/fpm/pool.d/www.conf`:
```ini
; Max execution time
max_execution_time = 300

; Upload file size
upload_max_filesize = 100M
post_max_size = 100M

; Memory limit
memory_limit = 512M
```

## 4. Monitoring & Maintenance

### Error Logs
```bash
tail -f storage/logs/laravel.log
```

### Scheduled Tasks (Cron)
```bash
* * * * * cd /var/www/fina_berry/Backend && php artisan schedule:run >> /dev/null 2>&1
```

### Backup Strategy
```bash
# Daily backup
0 2 * * * mysqldump -u user -p password fina_berry_prod | gzip > /backup/fina_berry_$(date +\%Y\%m\%d).sql.gz
```

## 5. API Endpoints Documentation

### Authentication
- `POST /api/register` - Register new user
- `POST /api/login` - Login user
- `POST /api/logout` - Logout user
- `GET /api/user` - Get current user

### Roles & Permissions (Admin Only)
- `GET /api/roles` - List all roles
- `POST /api/roles` - Create role
- `POST /api/roles/assign` - Assign role to user
- `DELETE /api/roles/{id}` - Delete role

### Dashboard
- `GET /api/dashboard/stats` - Get statistics
- `GET /api/dashboard/analytics` - Get analytics

## 6. Health Check Endpoint

Access: `https://api.yourdomain.com/up`

Expected Response: `200 OK`

## 7. Rate Limiting (Optional)

Add to `app/Http/Middleware/ApiMiddleware.php`:
```php
Route::middleware('throttle:60,1')->group(function () {
    Route::post('/api/login', ...);
    Route::post('/api/register', ...);
});
```
