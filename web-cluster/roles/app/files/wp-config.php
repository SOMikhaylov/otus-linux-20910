<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** MySQL database username */
define( 'DB_USER', 'wordpressuser' );

/** MySQL database password */
define( 'DB_PASSWORD', 'Password1!' );

/** MySQL hostname */
define( 'DB_HOST', '127.0.0.1:6033' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8mb4' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define( 'AUTH_KEY',         '-4m1cTN;?Ia/c<eRDVD-.6@ApQVQ!oiA^&4^(*WP8;6(!/%)ST;;O#Im0Ym%P.Q^' );
define( 'SECURE_AUTH_KEY',  '-Wy!EU8Fx!m&(6Z8ZD15zTOz)3fUP--=1/[>x nzU![clVM%F~I}X6M|R/{%@AR!' );
define( 'LOGGED_IN_KEY',    '!&vWXg<1y73%tAnZ=ANpU@IcG]5AB,u(v+AK[K=:&Sh#m^H#8yexvXrg&z,|s6/=' );
define( 'NONCE_KEY',        'v8fXR 0#~K*</r0lX,<q^N1yFp3wJBW)jQSwt$aQ^GM,5IUXw[^XLDa90m]h9#%4' );
define( 'AUTH_SALT',        '6A|Mf3.=ixx+yfi]>,Tb2KZ+:T`VBBB|j5*fMSHnE;+ncO:^#)O&gFZ(|DFnC6#l' );
define( 'SECURE_AUTH_SALT', 'iu,*k;vORRMq Oe(Z%)LC&d`wQGv[=hNYAVHfnD!iWlzPh:;.81>?-A3IwO{eEr`' );
define( 'LOGGED_IN_SALT',   '^%.b}G4#lQ8mEX^Sc2]X};#CtnqYcSgV>@SwchLd5pUfEvg4&^DJC;dv|$VBz+nR' );
define( 'NONCE_SALT',       'K635e~M]We*Qr=L}$Go:m_$nU9V4pZVx`j=?I,Mlim*Emzt7PS/>B57m. cR#GdT' );

/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
