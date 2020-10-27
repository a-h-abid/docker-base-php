ARG PHP_VERSION="7.4.11"

FROM php:${PHP_VERSION}-fpm

LABEL maintainer="Ahmedul Haque Abid <a_h_abid@hotmail.com>"

ARG HTTP_PROXY=""
ARG HTTPS_PROXY=""
ARG NO_PROXY="localhost,127.0.0.1"
ARG TIMEZONE="UTC"

ENV http_proxy="${HTTP_PROXY}" \
    https_proxy="${HTTPS_PROXY}" \
    no_proxy="${NO_PROXY}" \
    TZ="${TIMEZONE}" \
    COMPOSER_VERSION="1.10.15" \
    COMPOSER_HOME="/usr/local/composer"

USER root

RUN echo "-- Configure Timezone --" \
        && echo "${TIMEZONE}" > /etc/timezone \
        && rm /etc/localtime \
        && dpkg-reconfigure -f noninteractive tzdata \
    && echo "-- Install Dependencies --" \
        && apt-get update -y \
        && apt-get install -y --no-install-recommends \
            curl \
            g++ \
            gettext \
            libfreetype6-dev \
            libgmp-dev \
            libicu-dev \
            libjpeg-dev \
            libpng-dev \
            libpq-dev \
            libssl-dev \
            libxml2-dev \
            libz-dev \
            libzip-dev \
            openssl \
            unzip \
            zip \
            zlib1g-dev \
    && echo "-- Install PHP Extensions --" \
        && curl -o /usr/local/bin/install-php-extensions https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions \
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
        && apt-get purge -y \
            g++ \
        && apt-get autoremove -y \
        && apt-get clean -y \
        && rm -rf \
            /var/lib/apt/lists/* \
            /tmp/* \
            /var/tmp/*

# PHP Composer Installation & Directory Permissions
RUN curl -L -o /usr/local/bin/composer https://github.com/composer/composer/releases/download/${COMPOSER_VERSION}/composer.phar \
    && mkdir -p ${COMPOSER_HOME} \
    && mkdir /run/php \
    && chown -R www-data:www-data ${COMPOSER_HOME} /run/php \
    && chmod -R ugo+w ${COMPOSER_HOME} \
    && chmod -R g+s ${COMPOSER_HOME} \
    && chmod ugo+x /usr/local/bin/composer \
    && composer --version \
    && composer global require --no-interaction hirak/prestissimo

COPY --chown=root:root ./phpfpm/php.ini /usr/local/etc/php/conf.d/app-php.ini
COPY --chown=root:root ./phpfpm/www.conf /usr/local/etc/php-fpm.d/www.conf

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
    PHPFPM_CONF_WWW_LISTEN=9000 \
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

WORKDIR /var/www/html

RUN chown -R www-data:www-data /var/www

# Unset proxy, timezone ENVs
RUN unset http_proxy \
    && unset https_proxy \
    && unset no_proxy

CMD [ "php-fpm" ]
