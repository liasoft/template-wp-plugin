#!/bin/bash

echo "Running post-create setup for WordPress Plugin..."

# Change to workspace directory
cd /workspace || exit 1

# Verify vscode user is in www-data group
if groups vscode | grep -q '\bwww-data\b'; then
    echo "✓ vscode user is in www-data group"
else
    echo "⚠ Adding vscode user to www-data group..."
    sudo usermod -a -G www-data vscode
fi

# Set proper permissions for volume directories
# Using group-writable permissions so both vscode and www-data can access
echo "Setting up directory permissions..."
sudo chown -R vscode:www-data /workspace/node_modules /workspace/vendor 2>/dev/null || true
sudo chmod -R 775 /workspace/node_modules /workspace/vendor 2>/dev/null || true

# Ensure WordPress directory has proper group ownership
# Files should be owned by www-data but group-writable for vscode
sudo chown -R www-data:www-data /var/www/html 2>/dev/null || true
sudo chmod -R 775 /var/www/html 2>/dev/null || true

# Set umask for this session to ensure new files are group-writable
umask 002

# Install PHP dependencies via Composer
echo "Installing PHP dependencies..."
if [ -f "composer.json" ]; then
    composer install --no-interaction > /dev/null 2>&1 || echo "Composer install failed, continuing..."
    echo "PHP dependencies installation finished."
else
    echo "No composer.json found, skipping PHP dependencies."
fi

# Install Node.js dependencies
echo "Installing Node.js dependencies..."
if [ -f "package.json" ]; then
    npm install > /dev/null 2>&1 || echo "npm install failed, continuing..."
    echo "Node.js dependencies installation finished."
else
    echo "No package.json found, skipping Node.js dependencies."
fi

# Configure git for dev container environment
echo "Configuring git for dev container..."
git config core.filemode false

# ========================================
# Automated WordPress Installation
# ========================================
echo ""
echo "Setting up WordPress..."

# WordPress configuration
WP_URL="http://localhost:8000"
WP_TITLE="WordPress Dev"
WP_ADMIN_USER="admin"
WP_ADMIN_PASSWORD="admin"
WP_ADMIN_EMAIL="admin@example.com"

# Wait for WordPress files to be available
echo "Waiting for WordPress files..."
attempt=0
max_attempts=30
while [ ! -f "/var/www/html/wp-load.php" ]; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "WordPress files not found after $max_attempts attempts, skipping WordPress setup."
        exit 0
    fi
    echo "  Attempt $attempt/$max_attempts - waiting for WordPress files..."
    sleep 2
done
echo "WordPress files are ready!"

# Wait for database to be ready
echo "Waiting for database to be ready..."
attempt=0
max_attempts=30
while ! mysqladmin ping -h "db" --silent 2>/dev/null; do
    attempt=$((attempt + 1))
    if [ $attempt -ge $max_attempts ]; then
        echo "Database not ready after $max_attempts attempts, skipping WordPress setup."
        exit 0
    fi
    echo "  Attempt $attempt/$max_attempts - waiting for database..."
    sleep 2
done
echo "Database is ready!"

# Check if WordPress is already installed
if wp core is-installed --path=/var/www/html --allow-root 2>/dev/null; then
    echo "WordPress is already installed!"
else
    # Install WordPress
    echo "Installing WordPress..."
    wp core install \
        --path=/var/www/html \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    if [ $? -eq 0 ]; then
        echo "WordPress installed successfully!"
    else
        echo "WordPress installation failed. You may need to install manually."
    fi
fi

# Remove default plugins (Akismet and Hello Dolly)
echo "Removing default plugins..."
wp plugin deactivate akismet hello --path=/var/www/html --allow-root 2>/dev/null || true
wp plugin delete akismet hello --path=/var/www/html --allow-root 2>/dev/null || true

# Activate the plugin if it exists
PLUGIN_DIR="/var/www/html/wp-content/plugins/template-wp-plugin"
if [ -d "$PLUGIN_DIR" ]; then
    echo "Activating plugin..."
    wp plugin activate template-wp-plugin --path=/var/www/html --allow-root 2>/dev/null || true
fi

echo ""
echo "=========================================="
echo "WordPress Plugin Development Environment Ready!"
echo "=========================================="
echo "WordPress Site: $WP_URL"
echo "Admin URL:      $WP_URL/wp-admin"
echo "Admin User:     $WP_ADMIN_USER"
echo "Admin Password: $WP_ADMIN_PASSWORD"
echo ""
echo "Available tools:"
echo "- PHP $(php --version | head -n1)"
echo "- Node.js $(node --version)"
echo "- Composer $(composer --version 2>/dev/null | head -n1 || echo 'available')"
echo "- WP-CLI $(wp --version 2>/dev/null || echo 'available')"
echo "========================================"
