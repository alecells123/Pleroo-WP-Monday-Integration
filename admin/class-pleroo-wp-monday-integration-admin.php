<?php

/**
 * The admin-specific functionality of the plugin.
 *
 * @link       https://https://github.com/alecells123
 * @since      0.0.2
 *
 * @package    Wp_Plugin_Template
 * @subpackage Wp_Plugin_Template/admin
 */

/**
 * The admin-specific functionality of the plugin.
 *
 * Defines the plugin name, version, and two examples hooks for how to
 * enqueue the admin-specific stylesheet and JavaScript.
 *
 * @package    Wp_Plugin_Template
 * @subpackage Wp_Plugin_Template/admin
 * @author     Alec Ellsworth <alecellsworth1@gmail.com>
 */
class PlerooWPMondayIntegration_Admin {

	/**
	 * The ID of this plugin.
	 *
	 * @since      0.0.2
	 * @access   private
	 * @var      string    $plugin_name    The ID of this plugin.
	 */
	private $plugin_name;

	/**
	 * The version of this plugin.
	 *
	 * @since      0.0.2
	 * @access   private
	 * @var      string    $version    The current version of this plugin.
	 */
	private $version;

	/**
	 * Initialize the class and set its properties.
	 *
	 * @since      0.0.2
	 * @param      string    $plugin_name       The name of this plugin.
	 * @param      string    $version    The version of this plugin.
	 */
	public function __construct( $plugin_name, $version ) {

		$this->plugin_name = $plugin_name;
		$this->version = $version;

		add_action('admin_menu', array($this, 'add_plugin_admin_menu'));

	}

	/**
	 * Register the stylesheets for the admin area.
	 *
	 * @since      0.0.2
	 */
	public function enqueue_styles() {

		/**
		 * This function is provided for demonstration purposes only.
		 *
		 * An instance of this class should be passed to the run() function
		 * defined in Wp_Plugin_Template_Loader as all of the hooks are defined
		 * in that particular class.
		 *
		 * The Wp_Plugin_Template_Loader will then create the relationship
		 * between the defined hooks and the functions defined in this
		 * class.
		 */

		wp_enqueue_style( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'css/pleroo-wp-monday-integration-admin.css', array(), $this->version, 'all' );

	}

	/**
	 * Register the JavaScript for the admin area.
	 *
	 * @since      0.0.2
	 */
	public function enqueue_scripts() {

		/**
		 * This function is provided for demonstration purposes only.
		 *
		 * An instance of this class should be passed to the run() function
		 * defined in Wp_Plugin_Template_Loader as all of the hooks are defined
		 * in that particular class.
		 *
		 * The Wp_Plugin_Template_Loader will then create the relationship
		 * between the defined hooks and the functions defined in this
		 * class.
		 */

		wp_enqueue_script( $this->plugin_name, plugin_dir_url( __FILE__ ) . 'js/pleroo-wp-monday-integration-admin.js', array( 'jquery' ), $this->version, false );

	}

	/**
	 * Register the administration menu for this plugin into the WordPress Dashboard menu.
	 */
	public function add_plugin_admin_menu() {
		add_menu_page(
			'Plugin Settings', // Page title
			'My Plugin', // Menu title
			'manage_options', // Capability
			'pleroo-wp-monday-integration', // Menu slug
			array($this, 'display_plugin_admin_page'), // Function to output the content
			'dashicons-admin-generic', // Icon (you can change this)
			100 // Position
		);
	}

	/**
	 * Render the admin page for this plugin.
	 */
	public function display_plugin_admin_page() {
		?>
		<div class="wrap">
			<h1><?php echo esc_html(get_admin_page_title()); ?></h1>
			<p>Hello World!</p>
		</div>
		<?php
	}

}
