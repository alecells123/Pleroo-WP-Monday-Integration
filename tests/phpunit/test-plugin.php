<?php
/**
 * Class PluginTest
 */
class PluginTest extends WP_UnitTestCase {

    public function test_plugin_initialized() {
        $this->assertTrue( class_exists( 'WP_Plugin_Template' ) );
    }

    public function test_admin_menu_exists() {
        $this->assertTrue( has_action( 'admin_menu' ) );
    }

    // Add more tests as needed
} 