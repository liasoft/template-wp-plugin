#!/bin/bash

echo "Running post-create setup for WordPress Write AI Plugin..."

# Change to workspace directory
cd /workspace || exit 1

# Ensure proper ownership of volume directories
echo "Setting up directory permissions..."
sudo chown -R vscode:www-data /workspace/node_modules /workspace/vendor 2>/dev/null || true

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

echo ""
echo "=========================================="
echo "WordPress Write AI Plugin Development Environment Ready!"
echo "=========================================="
echo "WordPress Site: http://localhost:24511"
echo ""
echo "Available tools:"
echo "- PHP $(php --version | head -n1)"
echo "- Node.js $(node --version)"
echo "- Composer $(composer --version 2>/dev/null | head -n1 || echo 'available')"
echo "- WP-CLI $(wp --version 2>/dev/null || echo 'available')"
echo "========================================"
