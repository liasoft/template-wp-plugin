#!/bin/bash
set -e

# Get main version from plugin header
VERSION=$(grep -oP "Version:\s*\K[\d\.]+" template-wp-plugin.php)
ERRORS=0

echo "Checking version consistency: $VERSION"

# Check version constant (if exists)
if grep -q "define.*VERSION" template-wp-plugin.php; then
    CONST_VERSION=$(grep -oP "define\s*\([^']*'[^']*VERSION[^']*',\s*'\K[\d\.]+" template-wp-plugin.php)
    if [ "$VERSION" != "$CONST_VERSION" ]; then
        echo "❌ Plugin constant: $CONST_VERSION (should be $VERSION)"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ Plugin constant: $CONST_VERSION"
    fi
fi

# Check package.json (if exists)
if [ -f "package.json" ]; then
    PKG_VERSION=$(grep -oP '"version":\s*"\K[\d\.]+' package.json)
    if [ "$VERSION" != "$PKG_VERSION" ]; then
        echo "❌ package.json: $PKG_VERSION (should be $VERSION)"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ package.json: $PKG_VERSION"
    fi
fi

# Check CHANGELOG.md (if exists)
if [ -f "CHANGELOG.md" ]; then
    CHANGELOG_VERSION=$(grep -oP "## \[\K[\d\.]+" CHANGELOG.md | head -1)
    if [ "$VERSION" != "$CHANGELOG_VERSION" ]; then
        echo "❌ CHANGELOG.md: $CHANGELOG_VERSION (should be $VERSION)"
        ERRORS=$((ERRORS + 1))
    else
        echo "✅ CHANGELOG.md: $CHANGELOG_VERSION"
    fi
fi

# Result
if [ $ERRORS -eq 0 ]; then
    echo "🎉 All versions match!"
    exit 0
else
    echo "💥 $ERRORS version mismatches found"
    exit 1
fi
