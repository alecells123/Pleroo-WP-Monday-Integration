<?php

/**
 * The plugin bootstrap file
 *
 * This file is read by WordPress to generate the plugin information in the plugin
 * admin area. This file also includes all of the dependencies used by the plugin,
 * registers the activation and deactivation functions, and defines a function
 * that starts the plugin.
 *
 * @link              https://github.com/alecells123
 * @since      0.0.3
 * @package           Pleroo_Wp_Monday_Integration
 *
 * @wordpress-plugin
 * Plugin Name:       Pleroo WP Monday Integration
 * Plugin URI:        https://github.com/alecells123/Pleroo-WP-Monday-Integration
 * Description:       WordPress plugin for integrating Monday.com with WordPress
 * Version:           0.0.3
 * Author:            Alec Ellsworth
 * Author URI:        https://github.com/alecells123
 * License:           GPL-2.0+
 * License URI:       http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain:       pleroo-wp-monday-integration
 * Domain Path:       /languages
 */

// If this file is called directly, abort.
if ( ! defined( 'WPINC' ) ) {
	die;
}

/**
 * Currently plugin version.
 * Start at version 0.0.0 and use SemVer - https://semver.org
 * Rename this for your plugin and update it as you release new versions.
 */
define( 'PLEROO_WP_MONDAY_INTEGRATION_VERSION', '0.0.3' );

/**
 * The code that runs during plugin activation.
 * This action is documented in includes/class-pleroo-wp-monday-integration-activator.php
 */
function activate_pleroo_wp_monday_integration() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-pleroo-wp-monday-integration-activator.php';
	Pleroo_Wp_Monday_Integration_Activator::activate();
}

/**
 * The code that runs during plugin deactivation.
 * This action is documented in includes/class-pleroo-wp-monday-integration-deactivator.php
 */
function deactivate_pleroo_wp_monday_integration() {
	require_once plugin_dir_path( __FILE__ ) . 'includes/class-pleroo-wp-monday-integration-deactivator.php';
	Pleroo_Wp_Monday_Integration_Deactivator::deactivate();
}

register_activation_hook( __FILE__, 'activate_pleroo_wp_monday_integration' );
register_deactivation_hook( __FILE__, 'deactivate_pleroo_wp_monday_integration' );

/**
 * The core plugin class that is used to define internationalization,
 * admin-specific hooks, and public-facing site hooks.
 */
require plugin_dir_path( __FILE__ ) . 'includes/class-pleroo-wp-monday-integration.php';

/**
 * Begins execution of the plugin.
 *
 * Since everything within the plugin is registered via hooks,
 * then kicking off the plugin from this point in the file does
 * not affect the page life cycle.
 *
 * @since      0.0.3
 */
function run_pleroo_wp_monday_integration() {
    // Create plugin instance and run it
    $plugin = new Pleroo_Wp_Monday_Integration();
    $plugin->run();
}

/**
 * Plugin updater handler function.
 * Pings the Github repo that hosts the plugin to check for updates.
 */
function pleroo_wp_monday_integration_check_for_plugin_update( $transient ) {
    // If no update transient or transient is empty, return.
    if ( empty( $transient->checked ) ) {
        return $transient;
    }

    // Plugin slug, path to the main plugin file, and the URL of the update server
    $plugin_slug = 'pleroo-wp-monday-integration/pleroo-wp-monday-integration.php';
    $update_url = 'https://raw.githubusercontent.com/alecells123/Pleroo-WP-Monday-Integration/refs/heads/main/update-info.json';

    // Fetch update information from your server
    $response = wp_remote_get( $update_url );
    if ( is_wp_error( $response ) ) {
        return $transient;
    }

    // Parse the JSON response (update_info.json must return the latest version details)
    $update_info = json_decode( wp_remote_retrieve_body( $response ) );

    // If a new version is available, modify the transient to reflect the update
    if ( version_compare( $transient->checked[ $plugin_slug ], $update_info->new_version, '<' ) ) {
        $plugin_data = array(
            'slug'        => 'pleroo-wp-monday-integration',
            'plugin'      => $plugin_slug,
            'new_version' => $update_info->new_version,
            'url'         => $update_info->url,
            'package'     => $update_info->package, // URL of the plugin zip file
        );
        $transient->response[ $plugin_slug ] = (object) $plugin_data;
    }

    return $transient;
}
add_filter( 'pre_set_site_transient_update_plugins', 'pleroo_wp_monday_integration_check_for_plugin_update' );

// Run the plugin.
run_pleroo_wp_monday_integration();
