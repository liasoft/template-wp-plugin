#!/bin/bash

# Build and package the WordPress plugin for release
# Usage: ./scripts/build-plugin.sh [output-directory] [archive-name]
#
# Arguments:
#   output-directory: Directory where the plugin files will be staged (default: release)
#   archive-name: Name of the zip file to create (optional - if omitted, no archive is created)

set -e  # Exit on any error

# Default values
OUTPUT_DIR="${1:-release}"
ARCHIVE_NAME="${2:-}"

echo "🔧 Building WordPress plugin..."
echo "Output directory: $OUTPUT_DIR"
if [ -n "$ARCHIVE_NAME" ]; then
    echo "Archive name: $ARCHIVE_NAME"
else
    echo "No archive will be created"
fi

# Clean up any existing output directory
if [ -d "$OUTPUT_DIR" ]; then
    echo "Cleaning existing output directory..."
    rm -rf "$OUTPUT_DIR"
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

echo "Copying core plugin files..."

# Copy core plugin files and directories
if [ -d "admin" ]; then
    cp -r admin/ "$OUTPUT_DIR/"
fi

if [ -d "editor" ]; then
    cp -r editor/ "$OUTPUT_DIR/"
fi

# Note: vendor/ directory contains only dev dependencies (WPCS, PHP_CodeSniffer)
# and is not needed in the distribution package

# Copy main PHP files
for file in *.php; do
    if [ -f "$file" ]; then
        cp "$file" "$OUTPUT_DIR/"
    fi
done

# Copy essential files
if [ -f "LICENSE" ]; then
    cp LICENSE "$OUTPUT_DIR/"
fi

if [ -f "README.md" ]; then
    cp README.md "$OUTPUT_DIR/"
fi

echo "Copying built assets..."

# Copy built assets directory (npm run build should have created these)
if [ -d "assets" ]; then
    cp -r assets/ "$OUTPUT_DIR/"
fi

if [ -n "$ARCHIVE_NAME" ]; then
    echo "Creating archive..."

    # Create the zip archive
    cd "$OUTPUT_DIR"
    if command -v zip >/dev/null 2>&1; then
        zip -r "../$ARCHIVE_NAME" .
    else
        # Fallback to tar if zip is not available
        ARCHIVE_NAME="${ARCHIVE_NAME%.zip}.tar.gz"
        tar -czf "../$ARCHIVE_NAME" .
    fi
    cd ..

    # Get file size for display
    if command -v du >/dev/null 2>&1; then
        SIZE=$(du -h "$ARCHIVE_NAME" | cut -f1)
        echo "Plugin archive created: $ARCHIVE_NAME ($SIZE)"
    else
        echo "Plugin archive created: $ARCHIVE_NAME"
    fi

    # List contents for verification
    echo ""
    echo "Archive contents:"
    if command -v unzip >/dev/null 2>&1; then
        unzip -l "$ARCHIVE_NAME" | head -20
        TOTAL_FILES=$(unzip -l "$ARCHIVE_NAME" | tail -1 | awk '{print $2}')
        echo "Total files: $TOTAL_FILES"
    else
        echo "Note: unzip not available for content listing"
    fi
else
    echo "Plugin files ready in directory: $OUTPUT_DIR"

    # List directory contents for verification
    echo ""
    echo "Directory contents:"
    find "$OUTPUT_DIR" -type f | head -20
    TOTAL_FILES=$(find "$OUTPUT_DIR" -type f | wc -l)
    echo "Total files: $TOTAL_FILES"
fi

echo ""
echo "Build complete!"
