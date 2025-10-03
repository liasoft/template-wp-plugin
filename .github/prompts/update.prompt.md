---
mode: agent
description: Check and update dependencies.
---

Your task:
Check for outdated dependencies and update them if appropriate, ensuring compatibility and stability.

Update Process:
1. Check current dependency status with `composer outdated`
2. Review security advisories with `composer audit`
3. Analyze which dependencies can be safely updated
4. Check for breaking changes in major version updates
5. Update dependencies using appropriate composer commands
6. Verify that updates don't break existing functionality
7. Run linting and tests to ensure everything still works
8. Update lock file and document any significant changes

Update Guidelines:
- Prioritize security updates first
- Be cautious with major version updates (check changelogs)
- Update patch and minor versions more freely
- Test after each significant update
- Use `composer update --dry-run` to preview changes
- Consider updating dev dependencies separately from production ones

Commands to Use:
- `composer outdated` - Show outdated packages
- `composer audit` - Check for security vulnerabilities
- `composer update` - Update all dependencies
- `composer update package/name` - Update specific package
- `composer update --dry-run` - Preview updates without applying
- `composer show --tree` - Show dependency tree
- `composer run lint` - Verify code standards after updates

Post-Update Verification:
- Run `composer run lint` to ensure code standards compliance
- Check that all expected functionality still works
- Review any deprecation warnings or notices
- Update documentation if needed