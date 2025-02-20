#!/bin/bash

# Function to show usage
show_usage() {
    echo "Usage: $0 <new-plugin-name> <new-plugin-url> <new-plugin-author> <new-plugin-author-url>"
    echo "Example: $0 \"My Awesome Plugin\" \"https://github.com/username/My-Awesome-Plugin\" \"John Doe\" \"https://github.com/username\""
    exit 1
}

# Check if we have all arguments
if [ "$#" -ne 4 ]; then
    show_usage
fi

# Store arguments
NEW_PLUGIN_NAME="$1"
NEW_PLUGIN_URL="$2"
NEW_PLUGIN_AUTHOR="$3"
NEW_PLUGIN_AUTHOR_URL="$4"

# Convert plugin name to different formats
# "My Awesome Plugin" -> "my-awesome-plugin"
SLUG=$(echo "$NEW_PLUGIN_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
# "my-awesome-plugin" -> "my_awesome_plugin"
UNDERSCORE=$(echo "$SLUG" | sed 's/-/_/g')
# "My Awesome Plugin" -> "MyAwesomePlugin"
CAMELCASE=$(echo "$NEW_PLUGIN_NAME" | perl -pe 's/(^|[\s-])\w/\U$&/g' | sed 's/[[:space:]-]//g')

echo "Converting WP Plugin Template to $NEW_PLUGIN_NAME..."

# Create initial update-info.json with version 0.0.0
cat > update-info.json << EOL
{
    "new_version": "0.0.0",
    "url": "$NEW_PLUGIN_URL",
    "package": "$NEW_PLUGIN_URL/releases/download/v0.0.0/${SLUG}.zip",
    "version": "0.0.0"
}
EOL

# Rename files and directories more thoroughly
find . -depth -type f \( -name "*wp-plugin-template*" -o -name "*class-wp-plugin-template*" \) -execdir bash -c '
    old="${1#./}"
    new="${old//wp-plugin-template/'$SLUG'}"
    new="${new//class-wp-plugin-template/class-'$SLUG'}"
    if [ "$old" != "$new" ]; then
        mv "$old" "$new"
    fi
' bash {} \;

# Also rename directories
find . -depth -type d -name "*wp-plugin-template*" -execdir bash -c '
    old="${1#./}"
    new="${old//wp-plugin-template/'$SLUG'}"
    if [ "$old" != "$new" ]; then
        mv "$old" "$new"
    fi
' bash {} \;

# Process all files - using perl instead of sed for better compatibility
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/WP Plugin Template/$NEW_PLUGIN_NAME/g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/WP_Plugin_Template/$CAMELCASE/g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/wp-plugin-template/$SLUG/g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/wp_plugin_template/$UNDERSCORE/g" {} \;

# Process PHP files specifically
find . -type f -name "*.php" -exec perl -pi -e "s/class Wp_Plugin_Template/class $CAMELCASE/g" {} \;
find . -type f -name "*.php" -exec perl -pi -e "s/extends Wp_Plugin_Template/extends $CAMELCASE/g" {} \;
find . -type f -name "*.php" -exec perl -pi -e "s/new Wp_Plugin_Template/new $CAMELCASE/g" {} \;

# Replace author and URLs
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s|https://github.com/alecells123/WP-Plugin-Template|$NEW_PLUGIN_URL|g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s|https://github.com/alecells123|$NEW_PLUGIN_AUTHOR_URL|g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s|Alec Ellsworth|$NEW_PLUGIN_AUTHOR|g" {} \;

# Update GitHub Actions workflow
if [ -f ".github/workflows/github-actions.yaml" ]; then
    perl -pi -e "s/WP_PLUGIN_TEMPLATE_VERSION/${UNDERSCORE}_VERSION/g" .github/workflows/github-actions.yaml
    perl -pi -e "s/wp-plugin-template\.php/$SLUG.php/g" .github/workflows/github-actions.yaml
    perl -pi -e "s/class-wp-plugin-template\.php/class-$SLUG.php/g" .github/workflows/github-actions.yaml
    perl -pi -e "s/wp-plugin-template\.zip/$SLUG.zip/g" .github/workflows/github-actions.yaml
    REPO_NAME=$(echo "$NEW_PLUGIN_URL" | sed 's|.*/||')
    perl -pi -e "s|alecells123/WP-Plugin-Template|$NEW_PLUGIN_AUTHOR_URL/$REPO_NAME|g" .github/workflows/github-actions.yaml
fi

# Reset version numbers
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/Version:.*[0-9]+\.[0-9]+\.[0-9]+/Version:           0.0.0/g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/define\( '.*_VERSION', '[0-9]+\.[0-9]+\.[0-9]+' \)/define( '${UNDERSCORE}_VERSION', '0.0.0' )/g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/\@since.*[0-9]+\.[0-9]+\.[0-9]+/\@since      0.0.0/g" {} \;
find . -type f -not -path "*/\.*" -not -name "rename-plugin.sh" -exec perl -pi -e "s/\$this->version = '[0-9]+\.[0-9]+\.[0-9]+';/\$this->version = '0.0.0';/g" {} \;

echo "Plugin conversion complete!"
echo "New plugin details:"
echo "  Name: $NEW_PLUGIN_NAME"
echo "  Slug: $SLUG"
echo "  Main PHP Class: $CAMELCASE"
echo "  Function Prefix: ${UNDERSCORE}_"
echo "  Initial Version: 0.0.0"
echo ""
echo "Next steps:"
echo "1. Update your GitHub repository URL in update-info.json if different from $NEW_PLUGIN_URL"
echo "2. Create an initial git tag: git tag v0.0.0"
echo "3. Push the tag: git push origin v0.0.0"
echo "4. Push your changes to trigger the first release" 