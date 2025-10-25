---
mode: agent
description: Check and update dependencies.
---

Your task:
Check for outdated dependencies and update them if appropriate, ensuring compatibility and stability for both PHP (Composer) and JavaScript (npm) dependencies.

Update Process:
1. Check current dependency status:
   - PHP: `composer outdated`
   - Node.js: `npm outdated`
2. Review security advisories:
   - PHP: `composer audit`
   - Node.js: `npm audit`
3. Analyze which dependencies can be safely updated
4. Check for breaking changes in major version updates
5. Update dependencies using appropriate commands
6. Verify that updates don't break existing functionality
7. Run linting and tests to ensure everything still works
8. Update lock files and document any significant changes

Update Guidelines:
- Prioritize security updates first for both PHP and Node.js dependencies
- Be cautious with major version updates (check changelogs and breaking changes)
- Update patch and minor versions more freely
- Test after each significant update
- Use dry-run options to preview changes before applying
- Consider updating dev dependencies separately from production ones
- For WordPress projects, ensure compatibility with WordPress core and @wordpress packages

Commands to Use:

PHP (Composer):
- `composer outdated` - Show outdated packages
- `composer audit` - Check for security vulnerabilities
- `composer update` - Update all dependencies
- `composer update package/name` - Update specific package
- `composer update --dry-run` - Preview updates without applying
- `composer show --tree` - Show dependency tree
- `composer run lint` - Verify PHP code standards after updates

Node.js (npm):
- `npm outdated` - Show outdated packages
- `npm audit` - Check for security vulnerabilities
- `npm audit fix` - Automatically fix security issues
- `npm update` - Update all dependencies to latest compatible versions
- `npm install package@latest` - Update specific package to latest version
- `npm list --depth=0` - Show installed package tree
- `npm run lint:js` - Verify JavaScript code standards
- `npm run lint:css` - Verify CSS code standards
- `npm run build` - Build assets after updates to ensure compatibility

Post-Update Verification:
- Run PHP linting: `composer run lint` to ensure code standards compliance
- Run JavaScript/CSS linting: `npm run lint:js` and `npm run lint:css`
- Build assets: `npm run build` to ensure everything compiles correctly
- Check that all expected functionality still works
- Review any deprecation warnings or notices in both PHP and JavaScript
- Verify WordPress block functionality if applicable
- Update documentation if needed
- Commit updated lock files (composer.lock and package-lock.json)