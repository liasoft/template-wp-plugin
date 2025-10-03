<?php
/**
 * Plugin Name: Template WordPress Plugin
 * Plugin URI: https://github.com/svnscha/template-wp-plugin
 * Description: A minimal boilerplate for WordPress plugins.
 * Version: 1.0.1
 * Author: Your Name
 * Author URI: https://yourwebsite.com
 * License: Apache 2.0
 * License URI: https://www.apache.org/licenses/LICENSE-2.0
 * Requires at least: 6.0
 * Tested up to: 6.7
 * Requires PHP: 8.3
 *
 * @package TemplateWPPlugin
 */

// Prevent direct access.
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

/**
 * Plugin activation hook.
 */
function template_wp_plugin_activate() {
	// Activation logic here.
}
register_activation_hook( __FILE__, 'template_wp_plugin_activate' );

/**
 * Plugin deactivation hook.
 */
function template_wp_plugin_deactivate() {
	// Deactivation logic here.
}
register_deactivation_hook( __FILE__, 'template_wp_plugin_deactivate' );
