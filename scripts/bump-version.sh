#!/usr/bin/env bash
# Ironforge version bump script
# Usage: ./scripts/bump-version.sh <major|minor|patch>
#
# Bumps the version in plugin.json, updates CHANGELOG.md,
# creates a git commit, and tags the release.

set -euo pipefail

PLUGIN_JSON=".claude-plugin/plugin.json"
CHANGELOG="CHANGELOG.md"

if [ $# -ne 1 ] || [[ ! "$1" =~ ^(major|minor|patch)$ ]]; then
  echo "Usage: $0 <major|minor|patch>"
  exit 1
fi

BUMP_TYPE="$1"

# Read current version
CURRENT=$(grep -oP '"version":\s*"\K[0-9]+\.[0-9]+\.[0-9]+' "$PLUGIN_JSON")
if [ -z "$CURRENT" ]; then
  echo "Error: could not read version from $PLUGIN_JSON"
  exit 1
fi

IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT"

case "$BUMP_TYPE" in
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  patch) PATCH=$((PATCH + 1)) ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
TODAY=$(date +%Y-%m-%d)

echo "Bumping version: $CURRENT → $NEW_VERSION"

# Update plugin.json
sed -i "s/\"version\": \"$CURRENT\"/\"version\": \"$NEW_VERSION\"/" "$PLUGIN_JSON"

# Update CHANGELOG.md: replace [Unreleased] section header with new version
sed -i "s/^## \[Unreleased\]/## [Unreleased]\n\n## [$NEW_VERSION] - $TODAY/" "$CHANGELOG"

# Update comparison links at bottom of CHANGELOG
sed -i "s|\[Unreleased\]: \(.*\)/compare/v.*\.\.\.HEAD|[Unreleased]: \1/compare/v$NEW_VERSION...HEAD|" "$CHANGELOG"

# Add new version link before the last version link
PREV_TAG="v$CURRENT"
NEW_TAG="v$NEW_VERSION"
sed -i "/^\[$CURRENT\]/i [$NEW_VERSION]: https://github.com/RomainDECOSTER/ironforge/compare/$PREV_TAG...$NEW_TAG" "$CHANGELOG"

echo ""
echo "Updated $PLUGIN_JSON → $NEW_VERSION"
echo "Updated $CHANGELOG"
echo ""
echo "Next steps:"
echo "  1. Edit CHANGELOG.md to describe what changed in [$NEW_VERSION]"
echo "  2. git add $PLUGIN_JSON $CHANGELOG"
echo "  3. git commit -m \"Release v$NEW_VERSION\""
echo "  4. git tag v$NEW_VERSION"
echo "  5. git push origin main --tags"
