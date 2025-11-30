# Use official PHP development base image with PHP 8.3
FROM mcr.microsoft.com/devcontainers/php:8.3-bullseye

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        git \
        curl \
        wget \
        unzip \
        zip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libxml2-dev \
        libonig-dev \
        default-mysql-client \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        gd \
        mysqli \
        pdo_mysql \
        zip \
        xml \
        mbstring

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Install Node.js LTS
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install WP-CLI
RUN wget -O /usr/local/bin/wp https://github.com/wp-cli/wp-cli/releases/download/v2.8.1/wp-cli-2.8.1.phar \
    && chmod +x /usr/local/bin/wp

# Ensure www-data group exists and add vscode user to it
# This allows vscode user to read/write files owned by www-data (Apache/WordPress)
RUN getent group www-data || groupadd -g 33 www-data \
    && usermod -a -G www-data vscode \
    # Also ensure vscode's primary group can work with www-data files
    && mkdir -p /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html

# Set default umask so new files are group-writable
RUN echo "umask 002" >> /home/vscode/.bashrc

# Set working directory and ensure proper ownership
WORKDIR /workspace
RUN chown vscode:www-data /workspace \
    && chmod 775 /workspace
