#!/usr/bin/env python3
"""
WordPress Plugin Template Initialization Script

This script reads configuration from template.json and applies it to all
relevant files in the repository, effectively "rebranding" the plugin template.

Usage:
    1. Clone the template repository
    2. Edit template.json with your plugin details
    3. Run: python scripts/init-repo.py
    4. (Optional) Run with --dry-run to preview changes without applying them
    5. (Optional) Run with --keep-changelog to preserve existing changelog
"""

import json
import os
import re
import sys
import shutil
from pathlib import Path
from datetime import datetime


# Default template values (what we're replacing FROM)
TEMPLATE_DEFAULTS = {
    "plugin": {
        "name": "Template WordPress Plugin",
        "slug": "template-wp-plugin",
        "description": "A minimal boilerplate for WordPress plugins.",
        "version": "1.0.3",
        "uri": "https://github.com/liasoft/template-wp-plugin"
    },
    "author": {
        "name": "Liasoft GmbH",
        "uri": "https://github.com/liasoft/template-wp-plugin"
    },
    "php": {
        "namespace": "TemplateWPPlugin",
        "function_prefix": "template_wp_plugin",
        "constant_prefix": "TEMPLATE_PLUGIN"
    },
    "composer": {
        "name": "liasoft/template-wp-plugin"
    },
    "github": {
        "owner": "liasoft",
        "repo": "template-wp-plugin"
    }
}

# Files to process (relative to repo root)
FILES_TO_PROCESS = [
    "template-wp-plugin.php",  # Main plugin file (will be renamed)
    "README.md",
    "CHANGELOG.md",
    "composer.json",
    "phpcs.xml",
    "scripts/validate-versions.sh",
    "scripts/build-plugin.sh",
    ".github/workflows/ci.yml",
    ".github/workflows/release.yml",
]

# Files to skip during processing
FILES_TO_SKIP = [
    "template.json",
    "scripts/init-repo.py",
    "vendor/",
    ".git/",
    "node_modules/",
]


def load_config(config_path: Path) -> dict:
    """Load the template.json configuration file."""
    if not config_path.exists():
        print(f"❌ Error: {config_path} not found!")
        print("Please create template.json with your plugin configuration.")
        sys.exit(1)

    with open(config_path, 'r', encoding='utf-8') as f:
        return json.load(f)


def build_replacements(config: dict) -> list[tuple[str, str]]:
    """Build a list of (old_value, new_value) replacement tuples."""
    defaults = TEMPLATE_DEFAULTS
    replacements = []

    # Plugin replacements
    if config.get("plugin", {}).get("name") != defaults["plugin"]["name"]:
        replacements.append((defaults["plugin"]["name"], config["plugin"]["name"]))

    if config.get("plugin", {}).get("slug") != defaults["plugin"]["slug"]:
        replacements.append((defaults["plugin"]["slug"], config["plugin"]["slug"]))

    if config.get("plugin", {}).get("description") != defaults["plugin"]["description"]:
        replacements.append((defaults["plugin"]["description"], config["plugin"]["description"]))

    if config.get("plugin", {}).get("uri") != defaults["plugin"]["uri"]:
        replacements.append((defaults["plugin"]["uri"], config["plugin"]["uri"]))

    # Author replacements
    if config.get("author", {}).get("name") != defaults["author"]["name"]:
        replacements.append((defaults["author"]["name"], config["author"]["name"]))

    if config.get("author", {}).get("uri") != defaults["author"]["uri"]:
        replacements.append((defaults["author"]["uri"], config["author"]["uri"]))

    # PHP naming replacements
    if config.get("php", {}).get("namespace") != defaults["php"]["namespace"]:
        replacements.append((defaults["php"]["namespace"], config["php"]["namespace"]))

    if config.get("php", {}).get("function_prefix") != defaults["php"]["function_prefix"]:
        replacements.append((defaults["php"]["function_prefix"], config["php"]["function_prefix"]))

    if config.get("php", {}).get("constant_prefix") != defaults["php"]["constant_prefix"]:
        replacements.append((defaults["php"]["constant_prefix"], config["php"]["constant_prefix"]))

    # Composer replacements
    if config.get("composer", {}).get("name") != defaults["composer"]["name"]:
        replacements.append((defaults["composer"]["name"], config["composer"]["name"]))

    # GitHub replacements
    github_old = f"{defaults['github']['owner']}/{defaults['github']['repo']}"
    github_new = f"{config.get('github', {}).get('owner', defaults['github']['owner'])}/{config.get('github', {}).get('repo', defaults['github']['repo'])}"
    if github_old != github_new:
        replacements.append((github_old, github_new))

    return replacements


def should_skip_file(file_path: Path, repo_root: Path) -> bool:
    """Check if a file should be skipped."""
    rel_path = str(file_path.relative_to(repo_root))

    for skip_pattern in FILES_TO_SKIP:
        if rel_path.startswith(skip_pattern) or skip_pattern in rel_path:
            return True

    return False


def process_file(file_path: Path, replacements: list[tuple[str, str]], dry_run: bool = False) -> int:
    """Process a single file with replacements. Returns count of replacements made."""
    if not file_path.exists():
        return 0

    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except UnicodeDecodeError:
        # Skip binary files
        return 0

    original_content = content
    replacement_count = 0

    for old_value, new_value in replacements:
        if old_value in content:
            count = content.count(old_value)
            content = content.replace(old_value, new_value)
            replacement_count += count

    if content != original_content:
        if not dry_run:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
        return replacement_count

    return 0


def rename_main_plugin_file(repo_root: Path, old_slug: str, new_slug: str, dry_run: bool = False) -> bool:
    """Rename the main plugin file if slug changed."""
    old_file = repo_root / f"{old_slug}.php"
    new_file = repo_root / f"{new_slug}.php"

    if old_file.exists() and old_slug != new_slug:
        if not dry_run:
            shutil.move(old_file, new_file)
        return True
    return False


def update_version_script(repo_root: Path, old_slug: str, new_slug: str, dry_run: bool = False) -> bool:
    """Update the validate-versions.sh script with new plugin filename."""
    script_path = repo_root / "scripts" / "validate-versions.sh"

    if not script_path.exists():
        return False

    with open(script_path, 'r', encoding='utf-8') as f:
        content = f.read()

    old_filename = f"{old_slug}.php"
    new_filename = f"{new_slug}.php"

    if old_filename in content:
        content = content.replace(old_filename, new_filename)
        if not dry_run:
            with open(script_path, 'w', encoding='utf-8') as f:
                f.write(content)
        return True

    return False


def reset_changelog(repo_root: Path, config: dict, dry_run: bool = False) -> None:
    """Reset CHANGELOG.md for a fresh start."""
    changelog_path = repo_root / "CHANGELOG.md"
    plugin_name = config.get("plugin", {}).get("name", "My Plugin")
    version = config.get("plugin", {}).get("version", "1.0.0")
    date = datetime.now().strftime("%Y-%m-%d")

    new_changelog = f"""# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [{version}] - {date}

### Initial Release

First release of {plugin_name}.

#### Features

- Initial plugin setup
"""

    if not dry_run:
        with open(changelog_path, 'w', encoding='utf-8') as f:
            f.write(new_changelog)


def find_all_files(repo_root: Path) -> list[Path]:
    """Find all text files to process."""
    files = []

    for file_path in repo_root.rglob('*'):
        if file_path.is_file() and not should_skip_file(file_path, repo_root):
            # Check for common text file extensions
            if file_path.suffix in ['.php', '.md', '.json', '.xml', '.yml', '.yaml', '.sh', '.txt', '.css', '.js']:
                files.append(file_path)

    return files


def main():
    """Main initialization routine."""
    # Parse arguments
    dry_run = '--dry-run' in sys.argv
    keep_changelog = '--keep-changelog' in sys.argv

    if dry_run:
        print("🔍 DRY RUN MODE - No files will be modified\n")

    # Determine repo root (script is in scripts/)
    script_dir = Path(__file__).parent.resolve()
    repo_root = script_dir.parent

    print(f"📁 Repository root: {repo_root}")
    print()

    # Load configuration
    config_path = repo_root / "template.json"
    config = load_config(config_path)

    print("📋 Configuration loaded from template.json")
    print(f"   Plugin Name: {config.get('plugin', {}).get('name', 'N/A')}")
    print(f"   Plugin Slug: {config.get('plugin', {}).get('slug', 'N/A')}")
    print(f"   Author: {config.get('author', {}).get('name', 'N/A')}")
    print()

    # Build replacements
    replacements = build_replacements(config)

    if not replacements:
        print("ℹ️  No changes detected - template.json matches defaults.")
        print("   Edit template.json with your plugin details and run again.")
        return

    print(f"🔄 Found {len(replacements)} replacement(s) to make:")
    for old_val, new_val in replacements:
        # Truncate long values for display
        old_display = old_val[:40] + "..." if len(old_val) > 40 else old_val
        new_display = new_val[:40] + "..." if len(new_val) > 40 else new_val
        print(f"   '{old_display}' → '{new_display}'")
    print()

    # Find and process all files
    files = find_all_files(repo_root)
    total_replacements = 0
    modified_files = []

    print("📝 Processing files...")
    for file_path in files:
        count = process_file(file_path, replacements, dry_run)
        if count > 0:
            rel_path = file_path.relative_to(repo_root)
            modified_files.append(str(rel_path))
            total_replacements += count
            print(f"   ✓ {rel_path} ({count} replacement(s))")

    # Rename main plugin file if needed
    old_slug = TEMPLATE_DEFAULTS["plugin"]["slug"]
    new_slug = config.get("plugin", {}).get("slug", old_slug)

    if old_slug != new_slug:
        if rename_main_plugin_file(repo_root, old_slug, new_slug, dry_run):
            print(f"   ✓ Renamed {old_slug}.php → {new_slug}.php")

        if update_version_script(repo_root, old_slug, new_slug, dry_run):
            print(f"   ✓ Updated scripts/validate-versions.sh with new filename")

    # Reset changelog by default (unless --keep-changelog is specified)
    if not keep_changelog:
        reset_changelog(repo_root, config, dry_run)
        print("   ✓ Reset CHANGELOG.md for fresh start")

    print()
    print("=" * 50)
    print(f"✅ Initialization complete!")
    print(f"   Files modified: {len(modified_files)}")
    print(f"   Total replacements: {total_replacements}")

    if dry_run:
        print()
        print("ℹ️  This was a dry run. Run without --dry-run to apply changes.")
    else:
        print()
        print("📌 Next steps:")
        print("   1. Review the changes: git diff")
        print("   2. Install dependencies: composer install")
        print("   3. Run linter: composer run lint")
        print("   4. Commit your changes: git add -A && git commit -m 'chore: initialize plugin from template'")
        if not keep_changelog:
            print("   5. Consider updating CHANGELOG.md with your initial features")


if __name__ == "__main__":
    main()
