<?php
/**
 * Example of updating data via the plugin's API
 */

$item_id = 123;
$response = wp_remote_request( "http://your-site.com/wp-json/wp-plugin-template/v1/items/{$item_id}", array(
    'method' => 'PUT',
    'headers' => array(
        'Content-Type' => 'application/json',
        'Authorization' => 'Basic ' . base64_encode( 'username:password' )
    ),
    'body' => json_encode(array(
        'title' => 'Updated Title',
        'content' => 'Updated Content'
    ))
)); 