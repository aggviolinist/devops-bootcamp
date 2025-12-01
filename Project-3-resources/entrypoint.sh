#!/bin/bash
set -e

# Update .env file with runtime environment variables

export SECRET_NAME="ecs-rdss-secret-new"
export AWS_REGION="us-east-1"

if [ -f /var/www/html/.env ]; then
    echo "Updating .env with runtime environment variables..."

    # Debug: Show what variables are set
    echo "APP_URL: $APP_URL"
    echo "DB_HOST: $DB_HOST"
    echo "DB_DATABASE: $DB_DATABASE"

    SECRET_JSON=$(aws secretsmanager get-secret-value \
    --secret-id ${SECRET_NAME} \
    --region ${AWS_REGION} \
    --query SecretString \
    --output text 2>&1)

    export DB_USERNAME=$(echo $SECRET_JSON | jq -r .username)
    export DB_PASSWORD=$(echo $SECRET_JSON | jq -r .password)


    #Only update if environment variables are set
    [ ! -z "$APP_URL" ] && sed -i "s|^APP_URL=.*|APP_URL=${APP_URL}|" /var/www/html/.env
    [ ! -z "$DB_HOST" ] && sed -i "s|^DB_HOST=.*|DB_HOST=${DB_HOST}|" /var/www/html/.env
    [ ! -z "$DB_DATABASE" ] && sed -i "s|^DB_DATABASE=.*|DB_DATABASE=${DB_DATABASE}|" /var/www/html/.env
    [ ! -z "$DB_USERNAME" ] && sed -i "s|^DB_USERNAME=.*|DB_USERNAME=${DB_USERNAME}|" /var/www/html/.env
    [ ! -z "$DB_PASSWORD" ] && sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=${DB_PASSWORD}|" /var/www/html/.env
    [ ! -z "$APP_ENV" ] && sed -i "s|^APP_ENV=.*|APP_ENV=${APP_ENV}|" /var/www/html/.env
    [ ! -z "$APP_DEBUG" ] && sed -i "s|^APP_DEBUG=.*|APP_DEBUG=${APP_DEBUG}|" /var/www/html/.env
    [ ! -z "$APP_KEY" ] && sed -i "s|^APP_KEY=.*|APP_KEY=${APP_KEY}|" /var/www/html/.env

    echo ".env file updated successfully!"
fi

# Clear Laravel config cache to use new .env values
cd /var/www/html
php artisan config:clear 2>/dev/null || true
php artisan cache:clear 2>/dev/null || true

# Start the services
echo "Starting services..."
exec /usr/local/bin/start-services.sh

