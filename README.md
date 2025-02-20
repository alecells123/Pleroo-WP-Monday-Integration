=== Plugin Name ===
Contributors: github.com/alecells123    
Tags: comments, spam
Requires at least: 3.0.1
Tested up to: 3.4
Stable tag: 4.3
License: GPLv2 or later
License URI: http://www.gnu.org/licenses/gpl-2.0.html

Here is a short description of the plugin.  This should be no more than 150 characters.  No markup here.

== Description ==

This is the long description.  No limit, and you can use Markdown (as well as in the following sections).

For backwards compatibility, if this section is missing, the full length of the short description will be used, and
Markdown parsed.

A few notes about the sections above:

*   "Contributors" is a comma separated list of wp.org/wp-plugins.org usernames
*   "Tags" is a comma separated list of tags that apply to the plugin
*   "Requires at least" is the lowest version that the plugin will work on
*   "Tested up to" is the highest version that you've *successfully used to test the plugin*. Note that it might work on
higher versions... this is just the highest one you've verified.
*   Stable tag should indicate the Subversion "tag" of the latest stable version, or "trunk," if you use `/trunk/` for
stable.

    Note that the `readme.txt` of the stable tag is the one that is considered the defining one for the plugin, so
if the `/trunk/readme.txt` file says that the stable tag is `4.3`, then it is `/tags/4.3/readme.txt` that'll be used
for displaying information about the plugin.  In this situation, the only thing considered from the trunk `readme.txt`
is the stable tag pointer.  Thus, if you develop in trunk, you can update the trunk `readme.txt` to reflect changes in
your in-development version, without having that information incorrectly disclosed about the current stable version
that lacks those changes -- as long as the trunk's `readme.txt` points to the correct stable tag.

    If no stable tag is provided, it is assumed that trunk is stable, but you should specify "trunk" if that's where
you put the stable version, in order to eliminate any doubt.

== Installation ==

1. Clone this repository
2. Run the rename script:
```bash
./rename-plugin.sh "New Plugin Name" "https://github.com/yourusername/new-plugin" "Your Name" "https://github.com/yourusername"
```
3. Start coding!

## Features

- 🔄 Automatic updates via GitHub releases
- ⚙️ Admin interface setup
- 🚀 REST API examples
- ✅ Testing framework
- 📦 GitHub Actions for automated releases

## Directory Structure

pleroo-wp-monday-integration/
├── admin/ # Admin interface files
├── examples/
│ └── api/ # API usage examples
├── includes/ # Core plugin files
├── public/ # Public-facing functionality
├── tests/
│ └── phpunit/ # PHPUnit tests
├── .distignore # Files to exclude from release
├── .github/ # GitHub Actions workflows
├── rename-plugin.sh # Plugin renaming script
└── update-info.json # Update manifest


## Development

### Setting Up Development Environment

1. Install dependencies:
```bash
npm install
```

2. Set up WordPress testing environment:
```bash
bin/install-wp-tests.sh wordpress_test root '' localhost latest
```

### Running Tests
```bash
./vendor/bin/phpunit
```

### Creating a Release

1. Update version in `update-info.json`:
```bash
npm run release
```


### API Examples

The `examples/api` directory contains working examples for:
- CREATE: Adding new custom post types
- READ: Fetching plugin data
- UPDATE: Modifying plugin settings
- DELETE: Removing plugin data

See individual example files for detailed documentation.

## Deployment

1. Update version numbers in:
   - pleroo-wp-monday-integration.php
   - update-info.json

2. Push to main/master branch

3. GitHub Actions will:
   - Create a new release
   - Generate the plugin ZIP
   - Update version information

## Credits

Created by Alec Ellsworth