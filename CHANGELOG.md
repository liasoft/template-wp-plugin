# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2025-10-25

### Added
- Comprehensive dev environment setup with improved development containers
- Enhanced CI/CD pipeline improvements for better automation

### Changed  
- Improved development workflow and tooling
- Updated build and deployment processes

## [1.0.2] - 2025-10-25

### Added
- Plugin version constant `TEMPLATE_PLUGIN_VERSION` for better version management
- Enhanced version validation script to handle optional files gracefully
- Support for flexible plugin structures (minimal and complex)

### Changed
- Updated validation script to work with template plugins that only have basic structure
- Improved error handling in version validation with clearer output messages
- Made package.json and CHANGELOG.md optional in version validation

### Fixed
- Version synchronization across plugin header and constants
- Silent failures in version validation script
- Compatibility with minimal WordPress plugin structure

## [1.0.1] - 2025-10-05

### Fixed
- CI/CD pipeline improvements and updates
- Enhanced automated build process
- Repository rule compatibility for release workflow

## [1.0.0] - 2025-10-05

### Initial Release

The first release of Template WordPress Plugin, providing a minimal boilerplate for WordPress plugin development.

#### Features

- **Minimal Structure** - Clean, simple plugin template following WordPress coding standards
- **Development Tools** - PHP_CodeSniffer integration with WordPress Coding Standards (WPCS)
- **EditorConfig** - Consistent formatting across different editors and IDEs
- **Composer Integration** - Modern PHP dependency management and autoloading
- **GitHub Actions** - Automated linting and quality checks on pull requests
- **Activation Hooks** - Basic plugin activation and deactivation hook examples

#### Development Standards

- Tab indentation for PHP files (4 spaces width)
- WordPress Coding Standards compliance
- GPL-3.0-or-later license
- PHP 8.3+ compatibility
- WordPress 6.5+ compatibility

---

**Note**: This changelog will be maintained for all future releases. Each version will document new features, improvements, bug fixes, and any breaking changes.
