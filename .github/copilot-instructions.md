# WordPress Plugin Template Guidelines

## Development Philosophy

This template follows absolute minimalism - start simple, add complexity only when needed.

## Code Standards

### PHP Code Quality
- Uses WordPress Coding Standards (WPCS) with PHP_CodeSniffer
- Tab indentation (4 spaces width) for PHP files
- Check code: `composer run lint`
- Auto-fix issues: `composer run lint:fix`

### Editor Configuration
- EditorConfig ensures consistent formatting across editors
- PHP files: tabs, JSON/Markdown: spaces
- No CSS/JS assets by default (add only if needed)

## Minimal Plugin Structure

Keep it simple:
- Single main plugin file: `wp-plugin.php`
- Basic activation/deactivation hooks only
- No complex class architecture unless required
- No admin pages, assets, or translations unless needed

## Development Workflow

1. Copy this template for new plugins
2. Rename main plugin file: `wp-plugin.php` → `your-plugin.php`
3. Update plugin headers (name, description, author)
4. Install dev dependencies: `composer install`
5. Add functionality incrementally as needed
6. Run `composer run lint` before commits

## Adding Features

Only add what you actually need:
- Admin functionality: add directly to main file or create `admin/` if complex
- Public features: add to main file or create separate files as needed
- Assets: create `assets/` directory only when you have CSS/JS files
- Database: use activation/deactivation hooks in main file

## Deployment

- GitHub Actions automatically runs lint checks on PRs
- Dependabot keeps dependencies updated
- Release workflow creates plugin archives on tagged releases