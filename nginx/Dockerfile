ARG NGINX_VERSION="1.19.6"

FROM nginx:${NGINX_VERSION}

LABEL maintainer="Ahmedul Haque Abid <a_h_abid@hotmail.com>"

ENV TZ="UTC"

ENV NGINX_CONF_USER="www-data www-data" \
    NGINX_CONF_WORKER_PROCESSES="4" \
    NGINX_CONF_EVENTS_WORKER_CONNECTIONS="2048" \
    NGINX_CONF_HTTP_KEEPALIVE_TIMEOUT="15s" \
    NGINX_CONF_HTTP_GZIP_COMP_LEVEL="6" \
    NGINX_CONF_HTTP_CLIENT_MAX_BODY_SIZE="2m" \
    NGINX_VHOST_DNS_RESOLVER_IP="127.0.0.11" \
    NGINX_VHOST_ENABLE_HTTP_TRAFFIC="true" \
    NGINX_VHOST_ENABLE_HTTPS_TRAFFIC="false" \
    NGINX_VHOST_ENABLE_REDIRECT_HTTP_TO_HTTPS="false" \
    NGINX_VHOST_ENABLE_REDIRECT_FROM_TO="false" \
    NGINX_VHOST_HTTP_SERVER_NAME="_" \
    NGINX_VHOST_HTTPS_SERVER_NAME="_" \
    NGINX_VHOST_DOCUMENT_ROOT="/var/www/html" \
    NGINX_VHOST_REDIRECT_FROM_SERVER_NAME="www.example.com" \
    NGINX_VHOST_REDIRECT_TO_PROTOCOL="https" \
    NGINX_VHOST_REDIRECT_TO_SERVER_NAME="example.com" \
    NGINX_VHOST_UPSTREAM_PHPFPM_SERVICE_HOST_PORT="phpfpm:9000" \
    NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_READ_TIMEOUT="600" \
    NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_PASS="\$upstreamName" \
    NGINX_VHOST_UPSTREAM_ECHO_SERVICE_HOST_PORT="echo:6001" \
    NGINX_VHOST_UPSTREAM_MINIO_SERVICE_HOST_PORT="minio:9000" \
    NGINX_VHOST_SSL_CERTIFICATE="/etc/ssl/certs/ssl-cert-snakeoil.pem" \
    NGINX_VHOST_SSL_CERTIFICATE_KEY="/etc/ssl/certs/ssl-cert-snakeoil.key" \
    NGINX_VHOST_USE_ECHO="false" \
    NGINX_VHOST_USE_MINIO="false"

COPY --chown=root:root ./.commons/certs/* /etc/ssl/certs/
COPY --chown=root:root ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=root:root ./nginx/conf.d/*.conf /etc/nginx/conf.d/
COPY --chown=root:root ./nginx/includes/*.conf /etc/nginx/includes/
COPY --chown=root:root ./nginx/entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /var/www/html

RUN chmod ug+x /usr/local/bin/entrypoint.sh \
    && chown -R www-data:www-data /var/www

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD ["nginx"]
