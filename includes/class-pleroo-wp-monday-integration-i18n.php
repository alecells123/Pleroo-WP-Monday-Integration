<?php

/**
 * Define the internationalization functionality
 *
 * Loads and defines the internationalization files for this plugin
 * so that it is ready for translation.
 *
 * @link       https://https://github.com/alecells123
 * @since      
 *
 * @package    Wp_Plugin_Template
 * @subpackage Wp_Plugin_Template/includes
 */

/**
 * Define the internationalization functionality.
 *
 * Loads and defines the internationalization files for this plugin
 * so that it is ready for translation.
 *
 * @since      
 * @package    Wp_Plugin_Template
 * @subpackage Wp_Plugin_Template/includes
 * @author     Alec Ellsworth <alecellsworth1@gmail.com>
 */
class PlerooWPMondayIntegration_i18n {


	/**
	 * Load the plugin text domain for translation.
	 *
	 * @since      
	 */
	public function load_plugin_textdomain() {

		load_plugin_textdomain(
			'pleroo-wp-monday-integration',
			false,
			dirname( dirname( plugin_basename( __FILE__ ) ) ) . '/languages/'
		);

	}



}
