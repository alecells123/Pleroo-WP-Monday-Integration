#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 <version-number>"
    echo "Example: $0 0.0.1"
    echo "This script updates all version numbers in the plugin to match."
    exit 1
}

# Check if we have the version argument
if [ "$#" -ne 1 ]; then
    show_usage
fi

NEW_VERSION="$1"

# Validate version number format
if ! [[ $NEW_VERSION =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Version must be in format X.Y.Z (e.g., 0.0.1)"
    exit 1
fi

echo "Updating all version numbers to $NEW_VERSION..."

# Get the plugin slug from the main PHP file name
PLUGIN_SLUG=$(find . -maxdepth 1 -name "*.php" ! -name "index.php" -exec basename {} .php \;)
if [ -z "$PLUGIN_SLUG" ]; then
    echo "Error: Could not find main plugin file"
    exit 1
fi

# Convert slug to underscore format for constants
UNDERSCORE=$(echo "$PLUGIN_SLUG" | sed 's/-/_/g')

# List of files to exclude from version updates
EXCLUDE_FILES="-not -name 'rename-plugin.sh' -not -name 'sync-version.sh' -not -name '.git*'"

# Update version numbers in PHP files
find . -type f -name "*.php" -not -name "rename-plugin.sh" -exec perl -pi -e "s/Version:.*[0-9]+\.[0-9]+\.[0-9]+/Version:           $NEW_VERSION/g" {} \;
find . -type f -name "*.php" -not -name "rename-plugin.sh" -exec perl -pi -e "s/define\( '${UNDERSCORE}_VERSION', '[0-9]+\.[0-9]+\.[0-9]+' \)/define( '${UNDERSCORE}_VERSION', '$NEW_VERSION' )/g" {} \;
find . -type f -name "*.php" -not -name "rename-plugin.sh" -exec perl -pi -e "s/\@since.*[0-9]+\.[0-9]+\.[0-9]+/\@since      $NEW_VERSION/g" {} \;
find . -type f -name "*.php" -not -name "rename-plugin.sh" -exec perl -pi -e "s/\$this->version = '[0-9]+\.[0-9]+\.[0-9]+';/\$this->version = '$NEW_VERSION';/g" {} \;

# Update update-info.json
if [ -f "update-info.json" ]; then
    # Get the current GitHub URL from the file
    GITHUB_URL=$(grep -o 'https://github.com/[^"]*' update-info.json | head -1 | sed 's|/releases/.*||')
    
    # Update the JSON file
    cat > update-info.json << EOL
{
    "new_version": "$NEW_VERSION",
    "url": "$GITHUB_URL",
    "package": "$GITHUB_URL/releases/download/v$NEW_VERSION/${PLUGIN_SLUG}.zip",
    "version": "$NEW_VERSION"
}
EOL
fi

echo "Version update complete!"
echo "All version numbers have been updated to $NEW_VERSION"
echo ""
echo "Next steps:"
echo "1. Review the changes"
echo "2. Create a new git tag: git tag v$NEW_VERSION"
echo "3. Push the tag: git push origin v$NEW_VERSION"
echo "4. Push your changes to trigger a new release" 