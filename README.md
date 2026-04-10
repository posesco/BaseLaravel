# Laravel Docker Setup

## Tech Stack
- **PHP:** 8.4 (Alpine 3.23)
- **Nginx:** Latest (Alpine)
- **Composer:** 2.x (Latest)
- **Laravel:** 13.x
- **Frontend:** Vite 7, Tailwind CSS 4
- **Node.js/npm:** Latest (Alpine)
- **MariaDB:** 12.2
- **Alpine Linux:** 3.23

## Requirements
- Docker
- Docker Compose

## Installation

### 1. Create Laravel project
```bash
docker run --rm -v $(pwd):/app -w /app composer:2 create-project laravel/laravel src
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

### 5. Frontend Setup
```bash
docker compose exec app npm install
docker compose exec app npm run build # Or 'npm run dev' for development
```

### 6. Fix permissions
```bash
docker compose exec -u root app chown -R laravel:laravel vendor node_modules storage bootstrap/cache
docker compose exec app chmod -R 775 storage bootstrap/cache
```

## Access
- Application: http://localhost:8081
- Database: localhost:3306 (internal: mariadb:3306)

## Useful commands

### Artisan
```bash
docker compose exec app php artisan migrate
docker compose exec app php artisan make:controller ControllerName
docker compose exec app php artisan tinker
docker compose exec app php artisan test
```

### Composer
```bash
docker compose exec app composer install
docker compose exec app composer update
docker compose exec app composer require package/name
docker compose exec app composer dump-autoload
```

### Frontend (npm)
```bash
docker compose exec app npm install
docker compose exec app npm run dev
docker compose exec app npm run build
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
