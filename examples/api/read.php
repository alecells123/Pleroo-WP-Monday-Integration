<?php
/**
 * Example of reading data via the plugin's API
 */

// Get all items
$response = wp_remote_get( 'http://your-site.com/wp-json/pleroo-wp-monday-integration/v1/items' );

// Get specific item
$item_id = 123;
$response = wp_remote_get( "http://your-site.com/wp-json/pleroo-wp-monday-integration/v1/items/{$item_id}" );

if ( ! is_wp_error( $response ) ) {
    $body = wp_remote_retrieve_body( $response );
    $data = json_decode( $body );
    print_r( $data );
} 