#!/bin/bash
set -e;

## CONF

sed -i "s!\${NGINX_CONF_USER}!${NGINX_CONF_USER}!" /etc/nginx/nginx.conf
sed -i "s!\${NGINX_CONF_WORKER_PROCESSES}!${NGINX_CONF_WORKER_PROCESSES}!" /etc/nginx/nginx.conf
sed -i "s!\${NGINX_CONF_EVENTS_WORKER_CONNECTIONS}!${NGINX_CONF_EVENTS_WORKER_CONNECTIONS}!" /etc/nginx/nginx.conf
sed -i "s!\${NGINX_CONF_HTTP_KEEPALIVE_TIMEOUT}!${NGINX_CONF_HTTP_KEEPALIVE_TIMEOUT}!" /etc/nginx/nginx.conf
sed -i "s!\${NGINX_CONF_HTTP_GZIP_COMP_LEVEL}!${NGINX_CONF_HTTP_GZIP_COMP_LEVEL}!" /etc/nginx/nginx.conf
sed -i "s!\${NGINX_CONF_HTTP_CLIENT_MAX_BODY_SIZE}!${NGINX_CONF_HTTP_CLIENT_MAX_BODY_SIZE}!" /etc/nginx/nginx.conf

## VHOST

sed -i "s!\${NGINX_VHOST_HTTP_LISTEN_PORT}!${NGINX_VHOST_HTTP_LISTEN_PORT}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_HTTPS_LISTEN_PORT}!${NGINX_VHOST_HTTPS_LISTEN_PORT}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_HTTP_SERVER_NAME}!${NGINX_VHOST_HTTP_SERVER_NAME}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_HTTPS_SERVER_NAME}!${NGINX_VHOST_HTTPS_SERVER_NAME}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_DOCUMENT_ROOT}!${NGINX_VHOST_DOCUMENT_ROOT}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_REDIRECT_FROM_SERVER_NAME}!${NGINX_VHOST_REDIRECT_FROM_SERVER_NAME}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_REDIRECT_TO_PROTOCOL}!${NGINX_VHOST_REDIRECT_TO_PROTOCOL}!" /etc/nginx/conf.d/*
sed -i "s!\${NGINX_VHOST_REDIRECT_TO_SERVER_NAME}!${NGINX_VHOST_REDIRECT_TO_SERVER_NAME}!" /etc/nginx/conf.d/*

sed -i "s!\${NGINX_VHOST_SSL_CERTIFICATE}!${NGINX_VHOST_SSL_CERTIFICATE}!" /etc/nginx/includes/ssl-params.conf
sed -i "s!\${NGINX_VHOST_SSL_CERTIFICATE_KEY}!${NGINX_VHOST_SSL_CERTIFICATE_KEY}!" /etc/nginx/includes/ssl-params.conf

sed -i "s!\${NGINX_VHOST_DNS_RESOLVER_IP}!${NGINX_VHOST_DNS_RESOLVER_IP}!" /etc/nginx/includes/loc-*.conf

sed -i "s!\${NGINX_VHOST_UPSTREAM_PHPFPM_SERVICE_HOST_PORT}!${NGINX_VHOST_UPSTREAM_PHPFPM_SERVICE_HOST_PORT}!" /etc/nginx/includes/loc-phpfpm.conf
sed -i "s!\${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_READ_TIMEOUT}!${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_READ_TIMEOUT}!" /etc/nginx/includes/loc-phpfpm.conf
sed -i "s!\${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_PASS}!${NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_PASS}!" /etc/nginx/includes/loc-phpfpm.conf

sed -i "s!\${NGINX_VHOST_UPSTREAM_ECHO_SERVICE_HOST_PORT}!${NGINX_VHOST_UPSTREAM_ECHO_SERVICE_HOST_PORT}!" /etc/nginx/includes/loc-echo.conf
sed -i "s!\${NGINX_VHOST_UPSTREAM_MINIO_SERVICE_HOST_PORT}!${NGINX_VHOST_UPSTREAM_MINIO_SERVICE_HOST_PORT}!" /etc/nginx/includes/loc-minio.conf

if [ "${NGINX_VHOST_ENABLE_HTTP_TRAFFIC}" = "false" ]; then
    rm -f /etc/nginx/conf.d/default.conf
fi

if [ "${NGINX_VHOST_ENABLE_HTTPS_TRAFFIC}" = "false" ]; then
    rm -f /etc/nginx/conf.d/default-ssl.conf
fi

if [ "${NGINX_VHOST_ENABLE_REDIRECT_HTTP_TO_HTTPS}" = "false" ]; then
    rm -f /etc/nginx/conf.d/redirect-http-https.conf
fi

if [ "${NGINX_VHOST_ENABLE_REDIRECT_FROM_TO}" = "false" ]; then
    if [ "${NGINX_VHOST_ENABLE_HTTP_TRAFFIC}" = "false" ]; then
        rm -f /etc/nginx/conf.d/redirect-from-to-http.conf
    fi

    if [ "${NGINX_VHOST_ENABLE_HTTPS_TRAFFIC}" = "false" ]; then
        rm -f /etc/nginx/conf.d/redirect-from-to-https.conf
    fi
fi

if [ "${NGINX_VHOST_USE_PHPFPM}" = "false" ]; then
    rm -f /etc/nginx/includes/loc-phpfpm.conf
fi

if [ "${NGINX_VHOST_USE_ECHO}" = "false" ]; then
    rm -f /etc/nginx/includes/loc-echo.conf
fi

if [ "${NGINX_VHOST_USE_MINIO}" = "false" ]; then
    rm -f /etc/nginx/includes/loc-minio.conf
fi
