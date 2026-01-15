#!/bin/bash

# Version bumping script for tokenc
# Usage: ./bump_version.sh [major|minor|patch|X.Y.Z]

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get current version
CURRENT_VERSION=$(grep -m 1 'version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')

echo -e "${YELLOW}Current version: ${CURRENT_VERSION}${NC}"

# Parse version components
IFS='.' read -r -a VERSION_PARTS <<< "$CURRENT_VERSION"
MAJOR="${VERSION_PARTS[0]}"
MINOR="${VERSION_PARTS[1]}"
PATCH="${VERSION_PARTS[2]}"

# Determine new version
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No version type specified${NC}"
    echo "Usage: $0 [major|minor|patch|X.Y.Z]"
    echo ""
    echo "Examples:"
    echo "  $0 patch     # ${CURRENT_VERSION} → ${MAJOR}.${MINOR}.$((PATCH + 1))"
    echo "  $0 minor     # ${CURRENT_VERSION} → ${MAJOR}.$((MINOR + 1)).0"
    echo "  $0 major     # ${CURRENT_VERSION} → $((MAJOR + 1)).0.0"
    echo "  $0 1.2.3     # ${CURRENT_VERSION} → 1.2.3"
    exit 1
fi

case $1 in
    major)
        NEW_VERSION="$((MAJOR + 1)).0.0"
        ;;
    minor)
        NEW_VERSION="${MAJOR}.$((MINOR + 1)).0"
        ;;
    patch)
        NEW_VERSION="${MAJOR}.${MINOR}.$((PATCH + 1))"
        ;;
    *)
        # Check if it's a valid version number
        if [[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            NEW_VERSION=$1
        else
            echo -e "${RED}Error: Invalid version format${NC}"
            echo "Must be 'major', 'minor', 'patch', or a version number (X.Y.Z)"
            exit 1
        fi
        ;;
esac

echo -e "${GREEN}New version: ${NEW_VERSION}${NC}"
echo ""

# Confirm with user
read -p "Continue with version bump? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
    echo -e "${YELLOW}Warning: You have uncommitted changes.${NC}"
    echo "Current changes:"
    git status -s
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted. Please commit or stash your changes first."
        exit 0
    fi
fi

# Update version in files
echo "Updating version in files..."

# Update pyproject.toml
sed -i.bak "s/^version = \".*\"/version = \"${NEW_VERSION}\"/" pyproject.toml && rm pyproject.toml.bak
echo "✓ Updated pyproject.toml"

# Update setup.py
sed -i.bak "s/version=\"[^\"]*\"/version=\"${NEW_VERSION}\"/" setup.py && rm setup.py.bak
echo "✓ Updated setup.py"

# Update __init__.py
sed -i.bak "s/__version__ = \".*\"/__version__ = \"${NEW_VERSION}\"/" tokenc/__init__.py && rm tokenc/__init__.py.bak
echo "✓ Updated tokenc/__init__.py"

# Commit changes
echo ""
echo "Committing version bump..."
git add pyproject.toml setup.py tokenc/__init__.py
git commit -m "Bump version to ${NEW_VERSION}"
echo "✓ Committed changes"

# Create and push tag
echo ""
echo "Creating git tag v${NEW_VERSION}..."
git tag "v${NEW_VERSION}"
echo "✓ Created tag v${NEW_VERSION}"

echo ""
echo -e "${GREEN}Version bump complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Push the commit:  git push origin main"
echo "2. Push the tag:     git push origin v${NEW_VERSION}"
echo ""
echo "Or push both at once:"
echo "  git push origin main && git push origin v${NEW_VERSION}"
echo ""
echo "Once the tag is pushed, GitHub Actions will automatically:"
echo "  - Build the package"
echo "  - Publish to PyPI"
echo "  - Create a GitHub Release"
echo ""
read -p "Push now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Pushing to GitHub..."
    git push origin main
    git push origin "v${NEW_VERSION}"
    echo ""
    echo -e "${GREEN}✓ Pushed to GitHub!${NC}"
    echo ""
    echo "Watch the publish workflow at:"
    echo "https://github.com/$(git remote get-url origin | sed 's/.*github.com[:/]\(.*\)\.git/\1/')/actions"
else
    echo ""
    echo "Skipped push. Run the commands above when ready."
fi
