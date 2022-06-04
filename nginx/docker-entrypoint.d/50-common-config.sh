#!/bin/bash
set -e;

if [ "${NGINX_MODIFY_CONFIGS}" = "true" ]; then

    echo '!!! NGINX MODIFYING CONFIGS based on ENV !!!'

    ## CONF
    echo '--- Updating /etc/nginx/nginx.conf ---'
    sed -i "s!\${NGINX_CONF_USER}!${NGINX_CONF_USER}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_WORKER_PROCESSES}!${NGINX_CONF_WORKER_PROCESSES}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_EVENTS_WORKER_CONNECTIONS}!${NGINX_CONF_EVENTS_WORKER_CONNECTIONS}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_HTTP_KEEPALIVE_TIMEOUT}!${NGINX_CONF_HTTP_KEEPALIVE_TIMEOUT}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_HTTP_LOG_NOT_FOUND}!${NGINX_CONF_HTTP_LOG_NOT_FOUND}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_HTTP_GZIP_STATIC}!${NGINX_CONF_HTTP_GZIP_STATIC}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_HTTP_GZIP_MIN_LENGTH}!${NGINX_CONF_HTTP_GZIP_MIN_LENGTH}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_HTTP_GZIP_COMP_LEVEL}!${NGINX_CONF_HTTP_GZIP_COMP_LEVEL}!" /etc/nginx/nginx.conf
    sed -i "s!\${NGINX_CONF_HTTP_CLIENT_MAX_BODY_SIZE}!${NGINX_CONF_HTTP_CLIENT_MAX_BODY_SIZE}!" /etc/nginx/nginx.conf

    ## VHOST
    echo '--- Updating /etc/nginx/conf.d/* ---'
    sed -i "s!\${NGINX_VHOST_HTTP_LISTEN_PORT}!${NGINX_VHOST_HTTP_LISTEN_PORT}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_HTTPS_LISTEN_PORT}!${NGINX_VHOST_HTTPS_LISTEN_PORT}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_HTTP_SERVER_NAME}!${NGINX_VHOST_HTTP_SERVER_NAME}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_HTTPS_SERVER_NAME}!${NGINX_VHOST_HTTPS_SERVER_NAME}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_DOCUMENT_ROOT}!${NGINX_VHOST_DOCUMENT_ROOT}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_REDIRECT_FROM_SERVER_NAME}!${NGINX_VHOST_REDIRECT_FROM_SERVER_NAME}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_REDIRECT_TO_PROTOCOL}!${NGINX_VHOST_REDIRECT_TO_PROTOCOL}!" /etc/nginx/conf.d/*
    sed -i "s!\${NGINX_VHOST_REDIRECT_TO_SERVER_NAME}!${NGINX_VHOST_REDIRECT_TO_SERVER_NAME}!" /etc/nginx/conf.d/*

    echo '--- Updating /etc/nginx/includes/ssl-params.conf ---'
    sed -i "s!\${NGINX_VHOST_SSL_CERTIFICATE}!${NGINX_VHOST_SSL_CERTIFICATE}!" /etc/nginx/includes/ssl-params.conf
    sed -i "s!\${NGINX_VHOST_SSL_CERTIFICATE_KEY}!${NGINX_VHOST_SSL_CERTIFICATE_KEY}!" /etc/nginx/includes/ssl-params.conf

    echo '--- Updating /etc/nginx/includes/loc-*.conf ---'
    sed -i "s!\${NGINX_VHOST_LOCATION_ROOT_TRY_FILES}!${NGINX_VHOST_LOCATION_ROOT_TRY_FILES}!" /etc/nginx/includes/loc-root.conf

    echo '--- Updating /etc/nginx/includes/loc-*.conf for DNS Resolver ---'
    sed -i "s!\${NGINX_VHOST_DNS_RESOLVER_IP}!${NGINX_VHOST_DNS_RESOLVER_IP}!" /etc/nginx/includes/loc-*.conf

    if [ -f "/etc/nginx/includes/loc-phpfpm.conf" ]; then
        echo '--- Updating /etc/nginx/includes/loc-phpfpm.conf for PHPFPM ---'
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PHPFPM_SERVICE_HOST_PORT}!${NGINX_VHOST_UPSTREAM_PHPFPM_SERVICE_HOST_PORT}!" /etc/nginx/includes/loc-phpfpm.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_READ_TIMEOUT}!${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_READ_TIMEOUT}!" /etc/nginx/includes/loc-phpfpm.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_PASS}!${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_PASS}!" /etc/nginx/includes/loc-phpfpm.conf
    fi

    if [ -f "/etc/nginx/conf.d/upstream.conf" ]; then
        echo '--- Updating /etc/nginx/conf.d/upstream.conf for PROXYAPP ---'
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_KEEPALIVE}!${NGINX_VHOST_UPSTREAM_PROXYAPP_KEEPALIVE}!" /etc/nginx/conf.d/upstream.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_HOST_PORT}!${NGINX_VHOST_UPSTREAM_PROXYAPP_HOST_PORT}!" /etc/nginx/conf.d/upstream.conf
    fi

    if [ -f "/etc/nginx/includes/loc-proxyapp.conf" ]; then
        echo '--- Updating /etc/nginx/includes/loc-proxyapp.conf for PROXYAPP ---'
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_PROTOCOL}!${NGINX_VHOST_UPSTREAM_PROXYAPP_PROTOCOL}!" /etc/nginx/includes/loc-proxyapp.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_HOST_PORT}!${NGINX_VHOST_UPSTREAM_PROXYAPP_HOST_PORT}!" /etc/nginx/includes/loc-proxyapp.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_PASS}!${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_PASS}!" /etc/nginx/includes/loc-proxyapp.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_HEADER_X_FORWARDED_HOST}!${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_HEADER_X_FORWARDED_HOST}!" /etc/nginx/includes/loc-proxyapp.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_HEADER_X_FORWARDED_PROTO}!${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_HEADER_X_FORWARDED_PROTO}!" /etc/nginx/includes/loc-proxyapp.conf
        sed -i "s!\${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_HEADER_CONNECTION}!${NGINX_VHOST_UPSTREAM_PROXYAPP_PROXY_HEADER_CONNECTION}!" /etc/nginx/includes/loc-proxyapp.conf
    fi

    if [ -f "/etc/nginx/includes/loc-echo.conf" ]; then
        echo '--- Updating /etc/nginx/includes/loc-echo.conf for ECHO ---'
        sed -i "s!\${NGINX_VHOST_UPSTREAM_ECHO_SERVICE_HOST_PORT}!${NGINX_VHOST_UPSTREAM_ECHO_SERVICE_HOST_PORT}!" /etc/nginx/includes/loc-echo.conf
    fi

    if [ -f "/etc/nginx/includes/loc-minio.conf" ]; then
        echo '--- Updating /etc/nginx/includes/loc-minio.conf for MINIO ---'
        sed -i "s!\${NGINX_VHOST_UPSTREAM_MINIO_SERVICE_HOST_PORT}!${NGINX_VHOST_UPSTREAM_MINIO_SERVICE_HOST_PORT}!" /etc/nginx/includes/loc-minio.conf
    fi

    ## FILES REMOVAL
    echo '!!! Nginx files removal based on condition !!!'

    if [ "${NGINX_VHOST_ENABLE_HTTP_TRAFFIC}" = "false" ] && [ -f "/etc/nginx/conf.d/default.conf" ]; then
        rm -f /etc/nginx/conf.d/default.conf
    fi

    if [ "${NGINX_VHOST_ENABLE_HTTPS_TRAFFIC}" = "false" ] && [ -f "/etc/nginx/conf.d/default-ssl.conf" ]; then
        rm -f /etc/nginx/conf.d/default-ssl.conf
    fi

    if [ "${NGINX_VHOST_ENABLE_REDIRECT_HTTP_TO_HTTPS}" = "false" ] && [ -f "/etc/nginx/conf.d/redirect-http-https.conf" ]; then
        rm -f /etc/nginx/conf.d/redirect-http-https.conf
    fi

    if [ "${NGINX_VHOST_ENABLE_REDIRECT_FROM_TO}" = "true" ]; then
        if [ "${NGINX_VHOST_ENABLE_HTTP_TRAFFIC}" = "false" ] && [ -f "/etc/nginx/conf.d/redirect-from-to-http.conf" ]; then
            rm -f /etc/nginx/conf.d/redirect-from-to-http.conf
        fi

        if [ "${NGINX_VHOST_ENABLE_HTTPS_TRAFFIC}" = "false" ] && [ -f "/etc/nginx/conf.d/redirect-from-to-https.conf" ]; then
            rm -f /etc/nginx/conf.d/redirect-from-to-https.conf
        fi
    elif [ "${NGINX_VHOST_ENABLE_REDIRECT_FROM_TO}" = "false" ]; then
        if [ -f "/etc/nginx/conf.d/redirect-from-to-http.conf" ]; then
            rm -f /etc/nginx/conf.d/redirect-from-to-http.conf
        fi

        if [ -f "/etc/nginx/conf.d/redirect-from-to-https.conf" ]; then
            rm -f /etc/nginx/conf.d/redirect-from-to-https.conf
        fi
    fi

    if [ "${NGINX_VHOST_HTTP_USE_UPSTREAM_FILE}" = "false" ] && [ -f "/etc/nginx/conf.d/upstream.conf" ]; then
        rm -f /etc/nginx/conf.d/upstream.conf
    fi

    if [ "${NGINX_VHOST_USE_PHPFPM}" = "false" ] && [ -f "/etc/nginx/includes/loc-phpfpm.conf" ]; then
        rm -f /etc/nginx/includes/loc-phpfpm.conf
    fi

    if [ "${NGINX_VHOST_USE_PROXYAPP}" = "false" ] && [ -f "/etc/nginx/includes/loc-proxyapp.conf" ]; then
        rm -f /etc/nginx/includes/loc-proxyapp.conf
    fi

    if [ "${NGINX_VHOST_USE_ECHO}" = "false" ] && [ -f "/etc/nginx/includes/loc-echo.conf" ]; then
        rm -f /etc/nginx/includes/loc-echo.conf
    fi

    if [ "${NGINX_VHOST_USE_MINIO}" = "false" ] && [ -f "/etc/nginx/includes/loc-minio.conf" ]; then
        rm -f /etc/nginx/includes/loc-minio.conf
    fi

fi
