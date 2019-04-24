FROM php:7.3-apache-stretch

ENV COMPOSER_HOME /usr/bin/composer
WORKDIR /var/www
RUN rm -rf /var/www/html

#Install PHP extensions
RUN echo "@main39 http://dl-cdn.alpinelinux.org/alpine/v3.9/main" >> /etc/apk/repositories \
    && apk --no-cache add \
        $PHPIZE_DEPS \
        nano \
        git \
        apache-ant \
        openssl \
        supervisor \
        libxslt-dev \
        icu-dev \
        libjpeg-turbo \
        libpng-dev \
        libpng \
        libjpeg-turbo-dev \
        freetype-dev \
        freetype \
        libmemcached-dev \
        libzip-dev \
        zlib-dev \
        nodejs \
        npm \
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && pecl install \
        apcu \
        memcached \
    && docker-php-ext-install \
        opcache \
        pdo \
        pdo_mysql \
        xsl \
        intl \
        gd \
        zip \
    && docker-php-ext-enable \
        apcu \
        memcached \
        opcache \
    && apk del --no-cache \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev

# Install Composer
COPY --from=composer:latest $COMPOSER_HOME $COMPOSER_HOME