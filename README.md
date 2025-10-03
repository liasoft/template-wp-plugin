# WordPress Plugin Template

The absolute minimal WordPress plugin template. Just the essentials - activation, deactivation, and code quality tools.

## Features

- **WordPress Coding Standards** - WPCS with PHP_CodeSniffer for WordPress coding standards compliance
- **EditorConfig** - Consistent editor settings across different IDEs
- **Minimal Structure** - Just the bare essentials, no bloat
- **Plugin Hooks** - Basic activation and deactivation hooks ready to use

## Quick Start

### 1. Use This Template

Click "Use this template" on GitHub or clone this repository:

```bash
git clone https://github.com/liasoft/template-wp-plugin.git my-new-plugin
cd my-new-plugin
```

### 2. Customize Your Plugin

1. **Rename the main plugin file**: `wp-plugin.php` → `your-plugin-name.php`

2. **Update plugin headers** in your renamed file:
   - `Template WordPress Plugin` → `Your Plugin Name`
   - `A minimal boilerplate for WordPress plugins` → `Your plugin description`
   - `Your Name` → Your actual name
   - `https://yourwebsite.com` → Your website URL

3. **Update function names** to match your plugin (replace `template_wp_plugin` prefix)


### 3. Install Development Dependencies

```bash
composer install
```

### 4. Development Workflow

#### Code Quality

```bash
# Check code against WordPress Coding Standards
composer run lint

# Auto-fix coding standards violations where possible
composer run lint:fix
```

#### Testing Your Plugin

1. Copy to WordPress plugins directory:
   ```bash
   cp -r . /path/to/wordpress/wp-content/plugins/your-plugin-name/
   ```

2. Activate in WordPress admin dashboard
3. Your plugin is now active (it doesn't do anything yet - that's the point!)

## Project Structure

```
your-plugin-name/
├── .editorconfig         # Editor configuration
├── .gitignore            # Git ignore rules
├── phpcs.xml             # WordPress Coding Standards config
├── composer.json         # PHP dependencies and scripts
├── composer.lock         # Dependency lock file
├── LICENSE               # Apache 2.0 license
├── README.md             # This file
├── wp-plugin.php         # Main plugin file (rename this)
└── vendor/               # Composer dependencies (after install)
```

## What's Included

### Main Plugin File
- WordPress plugin header with all required metadata
- Direct access prevention
- Plugin activation hook (empty, ready for your code)
- Plugin deactivation hook (empty, ready for your code)

### Development Tools
- **WordPress Coding Standards**: Ensures your code follows WordPress coding standards and best practices
- **PHP_CodeSniffer**: Automated code standards checking and fixing
- **EditorConfig**: Consistent code formatting across different editors and IDEs

## Adding Your Features

The template provides activation and deactivation hooks where you can add your plugin logic:

```php
/**
 * Plugin activation hook.
 */
function template_wp_plugin_activate() {
	// Activation logic here.
}
register_activation_hook( __FILE__, 'template_wp_plugin_activate');

/**
 * Plugin deactivation hook.
 */
function template_wp_plugin_deactivate() {
	// Deactivation logic here.
}
register_deactivation_hook( __FILE__, 'template_wp_plugin_deactivate');
```

Add your plugin's main functionality after the hooks:

```php
// Add your plugin code here
// Example: Register shortcodes, add admin menus, enqueue scripts, etc.
```

**Important**: Remember to rename the functions with your own unique prefix to avoid conflicts with other plugins.

## Why So Minimal?

This template follows the principle of **absolute minimalism**:

- No unnecessary classes or complex architecture
- No assets directory (add only if you need it)
- No admin pages boilerplate (add only if you need it)
- No translation files (add only if you need it)
- No shortcodes or widgets (add only if you need it)

**Start simple, add complexity only when needed.**

## License

This template is licensed under the Apache 2.0 License.

## Support

- [WordPress Plugin Handbook](https://developer.wordpress.org/plugins/)
- [WordPress Coding Standards](https://make.wordpress.org/core/handbook/best-practices/coding-standards/)
- [GitHub Issues](https://github.com/liasoft/template-wp-plugin/issues)
