<?php
/**
 * Example of creating data via the plugin's API
 */

// Create a new custom post
$response = wp_remote_post( 'http://your-site.com/wp-json/wp-plugin-template/v1/items', array(
    'headers' => array(
        'Content-Type' => 'application/json',
        'Authorization' => 'Basic ' . base64_encode( 'username:password' )
    ),
    'body' => json_encode(array(
        'title' => 'Test Item',
        'content' => 'Test Content'
    ))
));

// Handle response
if ( is_wp_error( $response ) ) {
    echo 'Error: ' . $response->get_error_message();
} else {
    echo 'Created successfully!';
} 