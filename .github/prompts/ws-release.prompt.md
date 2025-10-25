---
mode: agent
description: Create a new release with proper version management and git tagging.
---

Your task:
Create a new release for the WordPress plugin by checking the current version state, determining the next version number, and creating the appropriate git tag.

Release Process:
1. Check the current latest release tag using `git tag -l "v*.*.*" --sort=-version:refname | head -1`
2. Display the current version and analyze what type of release is needed
3. **Review CHANGELOG.md** - Ensure it's updated with all changes since the last release
4. Present version increment options to the user:
   - **Patch release (X.Y.Z+1)**: Bug fixes, security patches, minor improvements
   - **Minor release (X.Y+1.0)**: New features, enhancements, backward-compatible changes
   - **Major release (X+1.0.0)**: Breaking changes, major architecture changes, API changes
5. **Update CHANGELOG.md** with the new version and release date if needed
6. Ask the user to confirm their choice and provide optional release notes
7. Update the plugin version in the main PHP file if needed
8. Create the git tag with proper annotation
9. Provide instructions for pushing the tag to trigger the release workflow

Version Analysis Guidelines:
- If no tags exist, suggest starting with v1.0.0
- Parse current version from git tags (format: v1.2.3)
- Consider the plugin's current state and recent changes
- Remind user about semantic versioning principles

Commands to Use:
- `git tag -l "v*.*.*" --sort=-version:refname` - List version tags sorted by version
- `git log --oneline $(git describe --tags --abbrev=0)..HEAD` - Show commits since last tag
- `git tag -a vX.Y.Z -m "Release version X.Y.Z"` - Create annotated tag
- `git push origin vX.Y.Z` - Push tag to trigger release workflow

Version Update Process:
1. **Review and update CHANGELOG.md**:
   - Add new version entry with current date
   - Include all changes since last release
   - Categorize changes (Added, Changed, Deprecated, Removed, Fixed, Security)
2. Check current version in `wp-plugin.php` header
3. If version in file doesn't match the new tag, update the Plugin Version header
4. Commit any version and changelog updates before creating the tag
5. Create the annotated git tag
6. Provide push instructions to the user

User Interaction:
- Show current version and recent commits since last release
- **Check CHANGELOG.md status** - verify it's up to date or needs updates
- Ask: "What type of release would you like to create?"
  - Option 1: Patch (bug fixes, small improvements)
  - Option 2: Minor (new features, enhancements)
  - Option 3: Major (breaking changes, major updates)
- Ask for confirmation of the suggested new version
- **Confirm CHANGELOG.md updates** or prompt to update if needed
- Optionally ask for custom release notes
- Confirm before creating the tag

Post-Release Instructions:
After creating the tag, provide these instructions to the user:

```
Release tag created successfully!

Next steps:
1. Push the tag to GitHub to trigger the release workflow:
   git push origin vX.Y.Z

2. The GitHub Actions workflow will automatically:
   - Run lint checks
   - Create a release archive
   - Create a GitHub release with release notes
   - Make the plugin zip file available for download

3. Monitor the Actions tab on GitHub to ensure the release completes successfully.
```

Error Handling:
- Check if working directory is clean before creating tags
- Verify that the current branch is the main/master branch
- Ensure git is configured properly for tagging
- Handle cases where no previous tags exist
- Validate version format and progression
