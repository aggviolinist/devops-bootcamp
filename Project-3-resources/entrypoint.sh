#!/bin/bash
set -e

echo "Starting entrypoint script..."

# Define paths
APP_PATH="/var/www/html"
ENV_FILE="$APP_PATH/.env"

# ================================================================
# STEP 1: Ensure .env file exists (create if missing)
# ================================================================

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env file not found at $ENV_FILE"
    exit 1
fi

echo "Found .env file at $ENV_FILE"

# ================================================================
# STEP 2: Wait for database to be available before proceeding
# ================================================================

if [ ! -z "$DB_HOST" ]; then
    echo "Waiting for database at $DB_HOST:${DB_PORT:-3306}..."
    max_attempts=30
    attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if nc -z "$DB_HOST" "${DB_PORT:-3306}" 2>/dev/null; then
            echo "Database is available!"
            break
        fi
        attempt=$((attempt + 1))
        echo "Database connection attempt $attempt/$max_attempts..."
        sleep 2
    done
    
    if [ $attempt -eq $max_attempts ]; then
        echo "WARNING: Could not connect to database after $max_attempts attempts"
    fi
fi

# ================================================================
# STEP 3: Update .env file with environment variables
# ================================================================

echo "Updating .env with runtime environment variables..."

# Debug: Show what variables are set
echo "--- Environment Variables ---"
echo "APP_URL: ${APP_URL:-NOT SET}"
echo "DB_HOST: ${DB_HOST:-NOT SET}"
echo "DB_DATABASE: ${DB_DATABASE:-NOT SET}"
echo "DB_USERNAME: ${DB_USERNAME:+SET (hidden)}"
echo "DB_PASSWORD: ${DB_PASSWORD:+SET (hidden)}"
echo "--- End Debug ---"

# Update .env file - use escaped separators for sed to handle special chars in passwords
# Only update if environment variables are set

[ ! -z "$APP_URL" ] && sed -i "s|^APP_URL=.*|APP_URL=${APP_URL}|" "$ENV_FILE" || true
[ ! -z "$DB_HOST" ] && sed -i "s|^DB_HOST=.*|DB_HOST=${DB_HOST}|" "$ENV_FILE" || true
[ ! -z "$DB_DATABASE" ] && sed -i "s|^DB_DATABASE=.*|DB_DATABASE=${DB_DATABASE}|" "$ENV_FILE" || true
[ ! -z "$DB_USERNAME" ] && sed -i "s|^DB_USERNAME=.*|DB_USERNAME=${DB_USERNAME}|" "$ENV_FILE" || true
[ ! -z "$DB_PASSWORD" ] && sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=${DB_PASSWORD}|" "$ENV_FILE" || true
[ ! -z "$APP_ENV" ] && sed -i "s|^APP_ENV=.*|APP_ENV=${APP_ENV}|" "$ENV_FILE" || true
[ ! -z "$APP_DEBUG" ] && sed -i "s|^APP_DEBUG=.*|APP_DEBUG=${APP_DEBUG}|" "$ENV_FILE" || true
[ ! -z "$APP_KEY" ] && sed -i "s|^APP_KEY=.*|APP_KEY=${APP_KEY}|" "$ENV_FILE" || true

echo ".env file updated successfully!"

# ================================================================
# STEP 4: Verify .env has been updated
# ================================================================

echo "--- Verifying .env contents ---"
grep -E "^DB_HOST|^DB_DATABASE|^DB_USERNAME|^APP_URL" "$ENV_FILE" || true
echo "--- End Verification ---"

# ================================================================
# STEP 5: Clear Laravel caches
# ================================================================

cd "$APP_PATH"

echo "Clearing Laravel caches..."
php artisan config:clear 2>&1 || echo "WARNING: config:clear failed"
php artisan cache:clear 2>&1 || echo "WARNING: cache:clear failed"
php artisan view:clear 2>&1 || echo "WARNING: view:clear failed"

# ================================================================
# STEP 6: Run Laravel migrations (optional - uncomment if needed)
# ================================================================

# Uncomment this if you want to auto-run migrations
# echo "Running database migrations..."
# php artisan migrate --force 2>&1 || echo "WARNING: migrations failed"

# ================================================================
# STEP 7: Start services
# ================================================================

echo "Starting PHP-FPM and Apache services..."
exec /usr/local/bin/start-services.sh