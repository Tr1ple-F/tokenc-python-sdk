# PyPI Automated Publishing Setup

This is a quick reference guide for setting up automated PyPI publishing for the `tokenc` package.

## One-Time Setup (Takes 5 minutes)

### 1. Create PyPI API Token

1. Go to https://pypi.org/account/register/ (if you don't have an account)
2. Log in and go to https://pypi.org/manage/account/token/
3. Click "Add API Token"
4. Fill in:
   - **Token name**: `tokenc-github-actions`
   - **Scope**: "Entire account" (for first publish) or "Project: tokenc" (after first publish exists)
5. Click "Add token"
6. **IMPORTANT**: Copy the token NOW (starts with `pypi-`)
   - You won't see it again!
   - Keep it safe temporarily - you'll need it in the next step

### 2. Add Token to GitHub Repository

1. Go to your GitHub repository: https://github.com/YOUR-USERNAME/ttc-sdk
2. Click **Settings** (top menu)
3. In the left sidebar: **Secrets and variables** → **Actions**
4. Click **"New repository secret"** button
5. Fill in:
   - **Name**: `PYPI_API_TOKEN` (must be exactly this)
   - **Secret**: Paste your PyPI token from step 1
6. Click **"Add secret"**

### 3. Enable GitHub Actions

1. In your repository, go to the **Actions** tab
2. If prompted, click **"I understand my workflows, go ahead and enable them"**
3. That's it!

## How to Publish a New Version

Once setup is complete, publishing is simple:

```bash
# Navigate to the repository
cd ttc-sdk

# Bump version and publish (interactive)
./bump_version.sh patch    # For bug fixes (0.1.0 → 0.1.1)
./bump_version.sh minor    # For new features (0.1.0 → 0.2.0)
./bump_version.sh major    # For breaking changes (0.1.0 → 1.0.0)
./bump_version.sh 1.5.2    # For specific version

# The script will:
# 1. Show you the version change
# 2. Ask for confirmation
# 3. Update all version files
# 4. Commit the changes
# 5. Create a git tag
# 6. Ask if you want to push
# 7. Push to GitHub (triggers automatic PyPI publish)
```

### What Happens Automatically

When you push the tag:

1. **GitHub Actions** detects the tag and starts the workflow
2. The workflow:
   - Builds the Python package
   - Runs quality checks
   - Publishes to PyPI
   - Creates a GitHub Release
3. **Within 2-3 minutes**, your package is live on PyPI!

### Monitoring the Release

- **GitHub Actions**: Check the "Actions" tab to see the workflow running
- **PyPI**: Visit https://pypi.org/project/tokenc/ to see your new version
- **GitHub Releases**: Check the "Releases" section for the auto-created release

## Troubleshooting

### "Permission denied" when running bump_version.sh

```bash
chmod +x bump_version.sh
```

### "Invalid credentials" in GitHub Actions

- Verify `PYPI_API_TOKEN` is set correctly in GitHub repository secrets
- Check the token hasn't expired on PyPI
- Ensure the token has the right scope (entire account or project scope)

### "File already exists" error

- You're trying to upload a version that already exists on PyPI
- Bump to a new version number
- You cannot re-upload the same version to PyPI

### Workflow doesn't trigger

- Make sure you pushed the tag: `git push origin vX.Y.Z`
- Check that the tag matches the pattern `v*.*.*` (e.g., `v0.1.0`, not `0.1.0`)
- Verify GitHub Actions is enabled in your repository

### First publish fails with "Project not found"

- For the first publish, your PyPI token must have "Entire account" scope
- After first successful publish, you can create a project-scoped token for better security

## Manual Publishing (If Needed)

If you need to publish manually without GitHub Actions:

```bash
# Install build tools
pip install build twine

# Build package
python -m build

# Upload to PyPI
twine upload dist/*
# Username: __token__
# Password: [paste your PyPI token]
```

## Version Numbering Guide

Follow [Semantic Versioning](https://semver.org/):

- **Patch** (0.0.X): Bug fixes, no API changes
  - Example: Fixed error handling bug

- **Minor** (0.X.0): New features, backward compatible
  - Example: Added new compression method

- **Major** (X.0.0): Breaking changes
  - Example: Changed API interface

## Security Notes

- **Never commit** `.pypirc` or any file containing your PyPI token
- **GitHub Secrets** are encrypted and only accessible to workflows
- **Rotate tokens** periodically for security
- **Use project-scoped tokens** after first publish for minimal permissions

## Getting Help

- Full documentation: See `PUBLISHING.md`
- GitHub Actions logs: Click on failed workflow runs to see detailed errors
- PyPI help: https://pypi.org/help/

## Quick Reference

```bash
# Common commands
./bump_version.sh patch              # Bug fix release
./bump_version.sh minor              # Feature release
./bump_version.sh major              # Breaking changes
git push origin main && git push origin vX.Y.Z  # Manual push
```

That's it! You're all set up for automated PyPI publishing.
