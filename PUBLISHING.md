# Publishing tokenc to PyPI

This guide will walk you through publishing the `tokenc` package to PyPI so users can install it with `pip install tokenc`.

## Prerequisites

1. **Create PyPI Accounts**
   - Main PyPI: https://pypi.org/account/register/
   - Test PyPI (for testing): https://test.pypi.org/account/register/

2. **Install Required Tools**
   ```bash
   pip install --upgrade build twine
   ```

## Step-by-Step Publishing Process

### 1. Prepare Your Package

Before publishing, ensure everything is ready:

```bash
# Check that all files are in place
ls -la

# Should see:
# - tokenc/ (package directory)
# - setup.py
# - pyproject.toml
# - README.md
# - LICENSE
# - MANIFEST.in
```

### 2. Update Version Number

When releasing updates, increment the version in:
- `setup.py` (line with `version="0.1.0"`)
- `pyproject.toml` (line with `version = "0.1.0"`)
- `tokenc/__init__.py` (line with `__version__ = "0.1.0"`)

Version numbering follows semantic versioning:
- `0.1.0` → `0.1.1` (bug fixes)
- `0.1.0` → `0.2.0` (new features)
- `0.1.0` → `1.0.0` (major changes/breaking)

### 3. Clean Previous Builds

```bash
# Remove old build artifacts
rm -rf build/ dist/ *.egg-info/
```

### 4. Build the Distribution

```bash
# Build source distribution and wheel
python -m build
```

This creates:
- `dist/tokenc-0.1.0.tar.gz` (source distribution)
- `dist/tokenc-0.1.0-py3-none-any.whl` (wheel distribution)

### 5. Test on Test PyPI (Recommended First Time)

```bash
# Upload to Test PyPI
python -m twine upload --repository testpypi dist/*

# You'll be prompted for:
# Username: your_testpypi_username
# Password: your_testpypi_password (or API token)
```

Test the installation:
```bash
# Create a test environment
python -m venv test_env
source test_env/bin/activate  # On Windows: test_env\Scripts\activate

# Install from Test PyPI
pip install --index-url https://test.pypi.org/simple/ tokenc

# Test it works
python -c "from tokenc import TokenClient; print('Success!')"

# Clean up
deactivate
rm -rf test_env
```

### 6. Publish to Production PyPI

Once tested, publish to the real PyPI:

```bash
# Upload to PyPI
python -m twine upload dist/*

# You'll be prompted for:
# Username: your_pypi_username
# Password: your_pypi_password (or API token)
```

### 7. Verify Installation

```bash
# Wait a few minutes for PyPI to process
# Then test installation
pip install tokenc

# Verify it works
python -c "from tokenc import TokenClient; print('Package published successfully!')"
```

## Using API Tokens (Recommended)

Instead of passwords, use API tokens for better security:

### Create API Tokens

1. **PyPI**: Go to https://pypi.org/manage/account/token/
2. **Test PyPI**: Go to https://test.pypi.org/manage/account/token/

Create a token with "Entire account" scope (or project-specific once published).

### Configure Tokens

Create `~/.pypirc` file:

```ini
[distutils]
index-servers =
    pypi
    testpypi

[pypi]
username = __token__
password = pypi-YOUR-API-TOKEN-HERE

[testpypi]
repository = https://test.pypi.org/legacy/
username = __token__
password = pypi-YOUR-TESTPYPI-TOKEN-HERE
```

Now you can upload without being prompted:

```bash
# Test PyPI
python -m twine upload --repository testpypi dist/*

# Production PyPI
python -m twine upload dist/*
```

## Automated Publishing with GitHub Actions (RECOMMENDED)

The repository is now configured with automated PyPI publishing! Here's how it works:

### One-Time Setup

1. **Get your PyPI API token**:
   - Go to https://pypi.org/manage/account/token/
   - Create a new API token (scope: "Entire account" or "Project: tokenc")
   - Copy the token (starts with `pypi-`)

2. **Add token to GitHub secrets**:
   - Go to your repository on GitHub
   - Click: Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `PYPI_API_TOKEN`
   - Value: paste your PyPI token
   - Click "Add secret"

### Publishing a New Version (Simple!)

Once setup is complete, publishing is as easy as:

```bash
# Use the helper script to bump version and publish
./bump_version.sh patch   # 0.1.0 → 0.1.1
./bump_version.sh minor   # 0.1.0 → 0.2.0
./bump_version.sh major   # 0.1.0 → 1.0.0
./bump_version.sh 1.2.3   # Set to specific version
```

**That's it!** The script will:
1. Update version in all files (pyproject.toml, setup.py, __init__.py)
2. Commit the changes
3. Create and push a git tag (e.g., `v0.1.1`)
4. GitHub Actions automatically builds and publishes to PyPI
5. Creates a GitHub Release

### How It Works

The workflow (`.github/workflows/publish.yml`) is triggered when you push a version tag:

- Detects tags matching `v*.*.*` (e.g., `v0.1.0`, `v1.2.3`)
- Automatically updates version in all files
- Builds the package
- Runs quality checks with twine
- Publishes to PyPI
- Creates a GitHub Release with artifacts

### Monitoring

After pushing a tag, you can watch the progress:

1. **GitHub Actions**: Go to "Actions" tab in your repo
2. **PyPI**: Check https://pypi.org/project/tokenc/ for the new version
3. **Releases**: New release appears in "Releases" section

### Manual Publishing (Alternative)

If you prefer manual control, you can still publish manually:

## Publishing Checklist

Before each release:

- [ ] Update version number in all files
- [ ] Update CHANGELOG.md (if you have one)
- [ ] Run tests: `pytest`
- [ ] Check code formatting: `black tokenc/`
- [ ] Update README.md if needed
- [ ] Clean old builds: `rm -rf dist/ build/ *.egg-info/`
- [ ] Build: `python -m build`
- [ ] Test on Test PyPI first
- [ ] Publish to PyPI
- [ ] Test installation: `pip install tokenc`
- [ ] Create git tag: `git tag v0.1.0 && git push --tags`

## Common Issues

### Issue: Package name already taken
**Solution**: Choose a different name. Check availability at https://pypi.org/project/YOUR-PACKAGE-NAME/

### Issue: "Invalid distribution file"
**Solution**: Make sure both `setup.py` and `pyproject.toml` are properly configured

### Issue: "File already exists"
**Solution**: You cannot re-upload the same version. Increment the version number.

### Issue: Import fails after installation
**Solution**: Make sure `tokenc/__init__.py` properly exports all classes

## After Publishing

1. **Create a GitHub Release**
   - Tag the release with version number (e.g., `v0.1.0`)
   - Include release notes

2. **Announce the Release**
   - Update your project website
   - Share on social media
   - Post in relevant communities

3. **Monitor**
   - Check PyPI stats: https://pypi.org/project/tokenc/
   - Watch for issues: https://github.com/yourusername/tokenc/issues

## Updating the Package

When you need to release an update:

```bash
# 1. Make your changes
# 2. Update version number
# 3. Clean and rebuild
rm -rf dist/ build/ *.egg-info/
python -m build

# 4. Upload new version
python -m twine upload dist/*
```

## Resources

- PyPI Documentation: https://packaging.python.org/
- Twine Documentation: https://twine.readthedocs.io/
- Semantic Versioning: https://semver.org/
- Python Packaging Guide: https://packaging.python.org/tutorials/packaging-projects/
