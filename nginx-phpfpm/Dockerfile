# syntax = docker/dockerfile:1

ARG PHP_VERSION="8.0.13"

FROM php:${PHP_VERSION}-fpm

LABEL maintainer="Ahmedul Haque Abid <a_h_abid@hotmail.com>"

ARG NGINX_VERSION="1.21.6"
ARG COMPOSER_VERSION="2.3.5"

ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ARG NO_PROXY="localhost,127.0.0.1"
ARG TIMEZONE="UTC"

ENV http_proxy="${HTTP_PROXY}" \
    https_proxy="${HTTPS_PROXY}" \
    no_proxy="${NO_PROXY}" \
    TZ="${TIMEZONE}" \
    NGINX_VERSION="${NGINX_VERSION}" \
    COMPOSER_VERSION="${COMPOSER_VERSION}" \
    COMPOSER_HOME="/usr/local/composer"

USER root

# S6 Overlay Setup Configuration
RUN curl -o /tmp/s6-overlay-installer https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer \
    && chmod +x /tmp/s6-overlay-installer && /tmp/s6-overlay-installer /

ENV S6_BEHAVIOUR_IF_STAGE2_FAILS="2" \
    S6_SERVICES_GRACETIME="3000" \
    S6_KILL_GRACETIME="5000" \
    S6_KILL_FINISH_MAXTIME="5000"

## Install Nginx + PHP Extensions
RUN --mount=type=cache,target=/var/cache/apt \
    echo "-- Configure Timezone --" \
        && echo "${TIMEZONE}" > /etc/timezone \
        && rm /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
    && echo "-- Install Dependencies --" \
        && apt update \
        && apt list --upgradable \
        && apt upgrade -y \
        && apt install -V -y --no-install-recommends --no-install-suggests \
            apt-transport-https \
            bc \
            ca-certificates \
            curl \
            gnupg1 \
            lsb-release \
            zip \
            unzip \
    && echo "-- Add APT Sources --" \
        && curl -L -o /tmp/nginx_signing.key 'https://nginx.org/keys/nginx_signing.key' \
        && apt-key add /tmp/nginx_signing.key \
        && echo "deb http://nginx.org/packages/mainline/debian/ $(lsb_release -sc) nginx" >> /etc/apt/sources.list \
        && apt update \
    && echo "-- Install Nginx --" \
        && apt install --no-install-recommends --no-install-suggests -y \
            nginx="${NGINX_VERSION}"-1~$(lsb_release -sc) \
    && echo "-- Install PHP Extensions --" \
        && curl -L -o /usr/local/bin/install-php-extensions https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions \
        && chmod a+x /usr/local/bin/install-php-extensions \
        && sync \
        && install-php-extensions \
            exif \
            intl \
            opcache \
            pcntl \
            pdo_mysql \
            sockets \
            zip \
    && echo "-- Cleanup Junks --" \
        && rm -f /usr/local/etc/php-fpm.d/zz-docker.conf | true \
        && rm -f /tmp/nginx_signing.key \
        && apt purge -y --auto-remove lsb-release \
        && apt clean -y \
        && apt autoremove -y \
        && rm -rf /var/lib/apt/lists/* \
    && echo "-- Additional Works --" \
        && mkdir /docker-entrypoint.nginx.d

# PHP Composer Installation & Directory Permissions
RUN curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && mkdir -p ${COMPOSER_HOME}/cache \
    && mkdir /run/php \
    && chown -R www-data:www-data ${COMPOSER_HOME} /run/php \
    && chmod -R ugo+w ${COMPOSER_HOME} \
    && chmod -R ug+s ${COMPOSER_HOME} \
    && chmod ugo+x /usr/local/bin/composer \
    && composer --version

COPY --chown=root:root ./.commons/php/php.ini /usr/local/etc/php/conf.d/app-php.ini
COPY --chown=root:root ./.commons/php/www.conf /usr/local/etc/php-fpm.d/www.conf

COPY --chown=root:root ./.commons/certs/* /etc/ssl/certs/
COPY --chown=root:root ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --chown=root:root ./nginx/conf.d/*.conf /etc/nginx/conf.d/
COPY --chown=root:root ./nginx/includes/*.conf /etc/nginx/includes/

COPY --chown=root:root ./nginx/docker-entrypoint.d/*.sh /docker-entrypoint.nginx.d/

# Copy service script
COPY ./nginx-phpfpm/start-nginx.sh /etc/services.d/nginx/run
COPY ./nginx-phpfpm/start-phpfpm.sh /etc/services.d/php_fpm/run

# PHP INI Settings for production by default
ENV PHP_INI_OUTPUT_BUFFERING=4096 \
    PHP_INI_MAX_EXECUTION_TIME=60 \
    PHP_INI_MAX_INPUT_TIME=60 \
    PHP_INI_MEMORY_LIMIT="256M" \
    PHP_INI_DISPLAY_ERRORS="Off" \
    PHP_INI_DISPLAY_STARTUP_ERRORS="Off" \
    PHP_INI_POST_MAX_SIZE="2M" \
    PHP_INI_FILE_UPLOADS="On" \
    PHP_INI_UPLOAD_MAX_FILESIZE="2M" \
    PHP_INI_MAX_FILE_UPLOADS="2" \
    PHP_INI_ALLOW_URL_FOPEN="On" \
    PHP_INI_ERROR_LOG="" \
    PHP_INI_DATE_TIMEZONE="${TIMEZONE}" \
    PHP_INI_SESSION_SAVE_HANDLER="files" \
    PHP_INI_SESSION_SAVE_PATH="/tmp" \
    PHP_INI_SESSION_USE_STRICT_MODE=0 \
    PHP_INI_SESSION_USE_COOKIES=1 \
    PHP_INI_SESSION_USE_ONLY_COOKIES=1 \
    PHP_INI_SESSION_NAME="APP_SSID" \
    PHP_INI_SESSION_COOKIE_SECURE="On" \
    PHP_INI_SESSION_COOKIE_LIFETIME=0 \
    PHP_INI_SESSION_COOKIE_PATH="/" \
    PHP_INI_SESSION_COOKIE_DOMAIN="" \
    PHP_INI_SESSION_COOKIE_HTTPONLY="On" \
    PHP_INI_SESSION_COOKIE_SAMESITE="" \
    PHP_INI_SESSION_UPLOAD_PROGRESS_NAME="APP_UPLOAD_PROGRESS" \
    PHP_INI_OPCACHE_ENABLE=1 \
    PHP_INI_OPCACHE_ENABLE_CLI=0 \
    PHP_INI_OPCACHE_MEMORY_CONSUMPTION=256 \
    PHP_INI_OPCACHE_INTERNED_STRINGS_BUFFER=16 \
    PHP_INI_OPCACHE_MAX_ACCELERATED_FILES=100000 \
    PHP_INI_OPCACHE_MAX_WASTED_PERCENTAGE=25 \
    PHP_INI_OPCACHE_USE_CWD=0 \
    PHP_INI_OPCACHE_VALIDATE_TIMESTAMPS=0 \
    PHP_INI_OPCACHE_REVALIDATE_FREQ=0 \
    PHP_INI_OPCACHE_SAVE_COMMENTS=0 \
    PHP_INI_OPCACHE_ENABLE_FILE_OVERRIDE=1 \
    PHP_INI_OPCACHE_MAX_FILE_SIZE=0 \
    PHP_INI_OPCACHE_FAST_SHUTDOWN=1

ENV PHPFPM_CONF_WWW_USER="www-data" \
    PHPFPM_CONF_WWW_GROUP="www-data" \
    PHPFPM_CONF_WWW_LISTEN="/run/php/php-fpm.sock" \
    PHPFPM_CONF_WWW_LISTEN_OWNER="www-data" \
    PHPFPM_CONF_WWW_LISTEN_GROUP="www-data" \
    PHPFPM_CONF_WWW_LISTEN_MODE=0660 \
    PHPFPM_CONF_WWW_PM="dynamic" \
    PHPFPM_CONF_WWW_PM_MAX_CHILDREN=5 \
    PHPFPM_CONF_WWW_PM_START_SERVERS=2 \
    PHPFPM_CONF_WWW_PM_MIN_SPARE_SERVERS=1 \
    PHPFPM_CONF_WWW_PM_MAX_SPARE_SERVERS=3 \
    PHPFPM_CONF_WWW_PM_PROCESS_IDLE_TIMEOUT="10s" \
    PHPFPM_CONF_WWW_PM_MAX_REQUESTS=0

ENV NGINX_MODIFY_CONFIGS="true" \
    NGINX_CONF_USER="www-data www-data" \
    NGINX_CONF_WORKER_PROCESSES="4" \
    NGINX_CONF_EVENTS_WORKER_CONNECTIONS="2048" \
    NGINX_CONF_HTTP_KEEPALIVE_TIMEOUT="15s" \
    NGINX_CONF_HTTP_LOG_NOT_FOUND="off" \
    NGINX_CONF_HTTP_GZIP_STATIC="off" \
    NGINX_CONF_HTTP_GZIP_MIN_LENGTH="20" \
    NGINX_CONF_HTTP_GZIP_COMP_LEVEL="6" \
    NGINX_CONF_HTTP_CLIENT_MAX_BODY_SIZE="2m" \
    NGINX_VHOST_HTTP_LISTEN_PORT="80" \
    NGINX_VHOST_HTTPS_LISTEN_PORT="443" \
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
    NGINX_VHOST_LOCATION_ROOT_TRY_FILES="\$uri \$uri/ /index.php\$is_args\$args" \
    NGINX_VHOST_UPSTREAM_PHPFPM_SERVICE_HOST_PORT="localhost:9000" \
    NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_READ_TIMEOUT="600" \
    NGINX_VHOST_UPSTREAM_PHPFPM_FASTCGI_PASS="unix:/run/php/php-fpm.sock" \
    NGINX_VHOST_UPSTREAM_ECHO_SERVICE_HOST_PORT="echo:6001" \
    NGINX_VHOST_UPSTREAM_MINIO_SERVICE_HOST_PORT="minio:9000" \
    NGINX_VHOST_SSL_CERTIFICATE="/etc/ssl/certs/ssl-cert-snakeoil.pem" \
    NGINX_VHOST_SSL_CERTIFICATE_KEY="/etc/ssl/certs/ssl-cert-snakeoil.key" \
    NGINX_VHOST_USE_PHPFPM="true" \
    NGINX_VHOST_USE_ECHO="false" \
    NGINX_VHOST_USE_MINIO="false"

WORKDIR /var/www/html

RUN chmod ugo+x /docker-entrypoint.nginx.d/*.sh \
    && chown -R www-data:www-data /var/www \
    && chmod -R ugo+w /etc/nginx/nginx.conf /etc/nginx/conf.d/ /etc/nginx/includes/ \
    && chmod 755 /etc/services.d/nginx/run \
    && chmod 755 /etc/services.d/php_fpm/run \
    && sed -i '/resolver \${NGINX_VHOST_DNS_RESOLVER_IP}/d' /etc/nginx/includes/loc-phpfpm.conf \
    && sed -i '/set \$upstreamName/d' /etc/nginx/includes/loc-phpfpm.conf

# Unset proxy, timezone ENVs
ENV http_proxy="" \
    https_proxy="" \
    no_proxy="" \
    TZ=""

STOPSIGNAL SIGTERM

ENTRYPOINT []

CMD ["/init"]

USER www-data
