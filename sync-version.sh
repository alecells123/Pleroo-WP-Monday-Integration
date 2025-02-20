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

# Get the plugin slug from the main PHP file that contains the plugin header
PLUGIN_SLUG=$(grep -l "Plugin Name:" *.php 2>/dev/null | grep -v "index.php" | grep -v "uninstall.php" | head -n1 | sed 's/\.php$//')
if [ -z "$PLUGIN_SLUG" ]; then
    echo "Error: Could not find main plugin file (looking for file with 'Plugin Name:' header)"
    exit 1
fi

# Convert slug to underscore format for constants
UNDERSCORE=$(echo "$PLUGIN_SLUG" | sed 's/-/_/g')
UNDERSCORE_UPPER=$(echo "$UNDERSCORE" | tr '[:lower:]' '[:upper:]')

# Update main plugin file
if [ -f "$PLUGIN_SLUG.php" ]; then
    # Update version in plugin header
    perl -i -pe "s/Version:\s*\d+\.\d+\.\d+/Version:           $NEW_VERSION/" "$PLUGIN_SLUG.php"
    
    # Update version constant - exact match to prevent contamination
    perl -i -pe "s/define\(\s*'PLEROO_WP_MONDAY_INTEGRATION_VERSION',\s*'\d+\.\d+\.\d+'\s*\)/define( 'PLEROO_WP_MONDAY_INTEGRATION_VERSION', '$NEW_VERSION' )/" "$PLUGIN_SLUG.php"
    
    # Update @since tags
    perl -i -pe "s/\@since\s*\d+\.\d+\.\d+/\@since      $NEW_VERSION/" "$PLUGIN_SLUG.php"
fi

# Update version in class files
find . -type f -name "class-*.php" | while read -r file; do
    perl -i -pe "s/\@since\s*\d+\.\d+\.\d+/\@since      $NEW_VERSION/" "$file"
    perl -i -pe "s/\\\$this->version\s*=\s*'\d+\.\d+\.\d+'/\\\$this->version = '$NEW_VERSION'/" "$file"
done

# Update update-info.json
if [ -f "update-info.json" ]; then
    # Create JSON with careful formatting
    cat > update-info.json << JSON
{
    "new_version": "$NEW_VERSION",
    "url": "https://github.com/alecells123/Pleroo-WP-Monday-Integration",
    "package": "https://github.com/alecells123/Pleroo-WP-Monday-Integration/releases/download/v$NEW_VERSION/$PLUGIN_SLUG.zip",
    "version": "$NEW_VERSION"
}
JSON
fi

echo "Version update complete!"
echo "All version numbers have been updated to $NEW_VERSION"
echo ""
echo "Next steps:"
echo "1. Review the changes"
echo "2. Create a new git tag: git tag v$NEW_VERSION"
echo "3. Push the tag: git push origin v$NEW_VERSION"
echo "4. Push your changes to trigger a new release" 