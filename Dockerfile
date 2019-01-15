FROM php:7.2-fpm-alpine

ENV APACHE_DOCROOT /var/www/html/public
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/www/html
ENV COMPOSER_HOME /usr/bin/composer

#Install PHP extensions
RUN echo "@main38 http://dl-cdn.alpinelinux.org/alpine/v3.8/main" >> /etc/apk/repositories \
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
    && docker-php-ext-configure gd \
        --with-gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ \
    && pecl install \
        apcu \
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
    && apk del --no-cache \
        freetype-dev \
        libpng-dev \
        libjpeg-turbo-dev 

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk --no-cache add ssmtp mailutils

RUN apk add --update ffmpeg

# Install Composer
COPY --from=composer:1.5 $COMPOSER_HOME $COMPOSER_HOME