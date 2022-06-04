# syntax=docker/dockerfile:1.3

ARG PHP_VERSION="8.0.13"

FROM php:${PHP_VERSION}-apache as base

LABEL maintainer="Ahmedul Haque Abid <a_h_abid@hotmail.com>"

ARG COMPOSER_VERSION="2.3.6"

ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ARG NO_PROXY="localhost,127.0.0.1"
ARG TIMEZONE="UTC"

ENV http_proxy="${HTTP_PROXY}" \
    https_proxy="${HTTPS_PROXY}" \
    no_proxy="${NO_PROXY}" \
    TZ="${TIMEZONE}" \
    COMPOSER_VERSION="${COMPOSER_VERSION}" \
    COMPOSER_HOME="/usr/local/composer"

USER root

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    echo "-- Configure Timezone --" \
        && echo "${TIMEZONE}" > /etc/timezone \
        && rm /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
    && echo "-- Install APT Dependencies --" \
        && apt update \
        && apt list --upgradable \
        && apt upgrade -y \
        && apt install -V -y --no-install-recommends --no-install-suggests \
            bc \
            curl \
            zip \
            unzip \
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
        && apt autoremove -y

# PHP Composer Installation & Directory Permissions
RUN curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && mkdir -p ${COMPOSER_HOME}/cache \
    && mkdir /run/php \
    && chown -R www-data:www-data ${COMPOSER_HOME} /run/php \
    && chmod -R ugo+w ${COMPOSER_HOME} \
    && chmod -R ug+s ${COMPOSER_HOME} \
    && chmod ugo+x /usr/local/bin/composer \
    && composer --version

# Certificates & entrypoint
COPY ./.commons/certs/* /etc/ssl/certs/
COPY --chown=root:root ./apache-php/entrypoint.sh /usr/local/bin/entrypoint.sh

# Apache Settings
COPY ./apache-php/apache2/* /etc/apache2/

ENV APACHE_ENABLE_HTTP_TRAFFIC="true" \
    APACHE_ENABLE_HTTPS_TRAFFIC="false" \
    APACHE_VHOST_SERVER_ADMIN="webmaster@example.com" \
    APACHE_VHOST_SERVER_NAME="_" \
    APACHE_VHOST_DOCUMENT_ROOT="/var/www/html" \
    APACHE_VHOST_HTTP_PORT="8080" \
    APACHE_VHOST_HTTPS_PORT="8443" \
    APACHE_VHOST_SSL_CERTIFICATE_FILE="/etc/ssl/certs/ssl-cert-snakeoil.pem" \
    APACHE_VHOST_SSL_CERTIFICATE_KEY_FILE="/etc/ssl/certs/ssl-cert-snakeoil.key"

# PHP INI Settings for production by default
COPY --chown=root:root ./.commons/php/php.ini /usr/local/etc/php/conf.d/app-php.ini

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

WORKDIR /var/www/html

RUN chmod ugo+x /usr/local/bin/entrypoint.sh \
    && a2enmod rewrite ssl \
    && a2ensite default-ssl \
    && chown -R www-data:www-data /var/www /etc/apache2/

# Unset proxy, timezone ENVs
ENV http_proxy="" \
    https_proxy="" \
    no_proxy="" \
    TZ=""

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]

CMD ["apache2-foreground"]

USER www-data
