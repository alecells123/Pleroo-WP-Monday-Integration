<?php
/**
 * Example of deleting data via the plugin's API
 */

$item_id = 123;
$response = wp_remote_request( "http://your-site.com/wp-json/wp-plugin-template/v1/items/{$item_id}", array(
    'method' => 'DELETE',
    'headers' => array(
        'Authorization' => 'Basic ' . base64_encode( 'username:password' )
    )
)); 