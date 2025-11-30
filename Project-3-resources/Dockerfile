# syntax=docker/dockerfile:1

# Use the latest version of the Amazon Linux base image
FROM amazonlinux:2023

# Avoid interactive prompts (if any)
ENV TERM=xterm \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Set the build argument directive (NON-SENSITIVE VALUES ONLY)
ARG GITHUB_USERNAME
ARG REPOSITORY_NAME
ARG APPLICATION_CODE_FILE_NAME

# Use the build argument to set environment variables (NON-SENSITIVE VALUES ONLY)
ENV GITHUB_USERNAME=$GITHUB_USERNAME
ENV REPOSITORY_NAME=$REPOSITORY_NAME
ENV APPLICATION_CODE_FILE_NAME=$APPLICATION_CODE_FILE_NAME

# ================================================================
# Install server dependencies
# ================================================================

# Update all packages
RUN yum update -y

# Install Git and unzip
RUN dnf install -y git unzip

# Install Git LFS
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | bash \
    && dnf install -y git-lfs \
    && git lfs install

# Install Apache, PHP and required extensions
RUN dnf install -y httpd php php-cli php-fpm php-mysqlnd php-bcmath php-ctype php-fileinfo php-json php-mbstring php-openssl php-pdo php-gd php-tokenizer php-xml php-curl

# Update memory_limit and max_execution_time in php.ini
RUN sed -i '/^memory_limit =/ s/=.*$/= 256M/' /etc/php.ini \
    && sed -i '/^max_execution_time =/ s/=.*$/= 300/' /etc/php.ini

# Enable mod_rewrite in Apache for .htaccess support
RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# ================================================================
# Upload application code to Container
# ================================================================

# Navigate to web directory
WORKDIR /var/www/html

# Clone the GitHub repository using BuildKit secret (this gets the LFS pointer files)
RUN git clone https://github.com/${GITHUB_USERNAME}/${REPOSITORY_NAME}.git repo \
    && cd repo \
    && git lfs pull \
    && cd .. \
    && cp -r repo/Project-3-resources/app/* . \
    && rm -rf repo

# Pull the actual LFS files

# Unzip the app code
RUN unzip ${APPLICATION_CODE_FILE_NAME}.zip

# Copy all files from 'shopwise' to web root
RUN cp -R ${APPLICATION_CODE_FILE_NAME}/. /var/www/html/

# Remove the 'shopwise' directory and zip file
RUN rm -rf ${APPLICATION_CODE_FILE_NAME} ${APPLICATION_CODE_FILE_NAME}.zip

# ================================================================
# Set permissions for directories
# ================================================================

# Set permissions for web and storage directories
RUN chmod -R 777 /var/www/html \
    && chmod -R 777 /var/www/html/bootstrap/cache/ \
    && chmod -R 777 /var/www/html/storage/
    
# ================================================================
# Replace the AppServiceProvider.php file
# ================================================================

# Replace AppServiceProvider.php
COPY AppServiceProvider.php app/Providers/AppServiceProvider.php

# ================================================================
# Configure locales, container startup, and expose ports
# ================================================================

# Expose the default Apache and MySQL ports
EXPOSE 80

# Install and configure locales for Amazon Linux 2023
RUN dnf install -y glibc-langpack-en && \
    dnf clean all

# Set locale environment variables
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Copy the start-services script into the container
COPY start-services.sh /usr/local/bin/start-services.sh

# Ensure the script is executable and fix any line ending issues
RUN chmod +x /usr/local/bin/start-services.sh && \
    sed -i 's/\r$//' /usr/local/bin/start-services.sh

# Run the script to start both PHP-FPM and Apache
CMD ["/usr/local/bin/start-services.sh"]