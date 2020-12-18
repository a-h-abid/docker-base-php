#!/bin/bash

set -e

if [ "$1" = "apache2-foreground" ]; then

    if [ "${APACHE_ENABLE_HTTP_TRAFFIC}" = "false" ]; then
        rm -f /etc/apache2/sites-available/000-default.conf
    fi

    if [ "${APACHE_ENABLE_HTTPS_TRAFFIC}" = "false" ]; then
        rm -f /etc/apache2/sites-available/default-ssl.conf
    fi

fi

exec "$@"
