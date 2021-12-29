#!/usr/bin/with-contenv bash
set -e;

echo "[phpfpm] Starting PHP-FPM..."

# Start PHP-FPM
/usr/local/sbin/php-fpm
