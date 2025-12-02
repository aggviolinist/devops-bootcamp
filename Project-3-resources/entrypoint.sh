#!/bin/bash
set -x

echo "========== ENTRYPOINT STARTED =========="

# Define paths
APP_PATH="/var/www/html"
ENV_FILE="$APP_PATH/.env"

# ================================================================
# STEP 1: Ensure .env file exists
# ================================================================

if [ ! -f "$ENV_FILE" ]; then
    echo "ERROR: .env file not found at $ENV_FILE"
    exit 1
fi

echo "Found .env file at $ENV_FILE"

# ================================================================
# STEP 2: Skip database check
# ================================================================

echo "Skipping database check - proceeding with startup"

# ================================================================
# STEP 3: DEBUG - Show environment variables BEFORE update
# ================================================================

echo ""
echo "========== DEBUG: Environment Variables BEFORE Update =========="
echo "APP_URL=${APP_URL:-NOT SET}"
echo "DB_HOST=${DB_HOST:-NOT SET}"
echo "DB_DATABASE=${DB_DATABASE:-NOT SET}"
echo "DB_USERNAME=${DB_USERNAME:-NOT SET}"
echo "DB_PASSWORD=${DB_PASSWORD:+SET}"
echo "========== END DEBUG =========="
echo ""

# ================================================================
# STEP 4: Update .env file with environment variables
# ================================================================

echo "Updating .env with runtime environment variables..."

sed -i "/^APP_URL=/ s|=.*$|=${APP_URL}|" "$ENV_FILE"
sed -i "/^DB_HOST=/ s|=.*$|=${DB_HOST}|" "$ENV_FILE"
sed -i "/^DB_DATABASE=/ s|=.*$|=${DB_DATABASE}|" "$ENV_FILE"
sed -i "/^DB_USERNAME=/ s|=.*$|=${DB_USERNAME}|" "$ENV_FILE"
sed -i "/^DB_PASSWORD=/ s|=.*$|=${DB_PASSWORD}|" "$ENV_FILE"
sed -i "/^APP_ENV=/ s|=.*$|=${APP_ENV}|" "$ENV_FILE"
sed -i "/^APP_DEBUG=/ s|=.*$|=${APP_DEBUG}|" "$ENV_FILE"
sed -i "/^APP_KEY=/ s|=.*$|=${APP_KEY}|" "$ENV_FILE"

echo ".env file updated successfully!"

# ================================================================
# STEP 5: DEBUG - Show .env file AFTER update
# ================================================================

echo ""
echo "========== DEBUG: .env Contents AFTER Update =========="
grep -E "^(APP_|DB_)" "$ENV_FILE" || echo "NO VALUES FOUND"
echo "========== END DEBUG =========="
echo ""

# ================================================================
# STEP 6: Clear Laravel caches
# ================================================================

cd "$APP_PATH"

echo "Clearing Laravel caches..."
php artisan config:clear 2>&1 || echo "WARNING: config:clear failed"
php artisan cache:clear 2>&1 || echo "WARNING: cache:clear failed"
php artisan view:clear 2>&1 || echo "WARNING: view:clear failed"
php artisan migrate --force 2>&1 || echo "WARNING: migrations failed"


# ================================================================
# STEP 7: Start services
# ================================================================

echo "========== STARTING SERVICES =========="
exec /usr/local/bin/start-services.sh