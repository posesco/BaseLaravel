# Laravel Docker Setup

## Tech Stack
- **PHP:** 8.4
- **Nginx:** Latest (Alpine)
- **Composer:** 2.9.2
- **Laravel:** 11.x (latest)
- **MariaDB:** 11.8.5
- **Alpine Linux:** 3.23.0

## Requirements
- Docker
- Docker Compose

## Installation

### 1. Create Laravel project
```bash
docker run --rm -v $(pwd):/app -w /app composer:2.9.2 create-project laravel/laravel src
```
### 2. Create .env file for Docker
```bash
cat > .env << EOF
USER_ID=$(id -u)
GROUP_ID=$(id -g)
EOF
```
### 3. Build and start containers
```bash
docker compose build --no-cache
docker compose up -d
```

### 4. Configure Laravel
```bash
docker compose exec app cp .env.example .env
docker compose exec app php artisan key:generate
docker compose exec app php artisan migrate
```

### 5. Fix permissions
```bash
docker compose exec -u root app chown -R laravel:laravel storage bootstrap/cache
docker compose exec app chmod -R 775 storage bootstrap/cache
```

## Access
- Application: http://localhost:8080
- Database: localhost:3306

## Useful commands

### Artisan
```bash
docker compose exec app php artisan migrate
docker compose exec app php artisan make:controller ControllerName
docker compose exec app php artisan tinker
```

### Composer
```bash
docker compose exec app composer install
docker compose exec app composer require package/name
docker compose exec app composer dump-autoload
```

### Logs
```bash
docker compose logs -f app
docker compose exec app tail -f storage/logs/laravel.log
```

### Container management
```bash
docker compose up -d
docker compose down
docker compose restart app
docker compose exec app sh
```

### Clear caches
```bash
docker compose exec app php artisan config:clear
docker compose exec app php artisan cache:clear
docker compose exec app php artisan view:clear
docker compose exec app php artisan route:clear
```

## Database Credentials
- Host: mariadb
- Database: laravel
- Username: laravel
- Password: secret
- Root Password: root