FROM php:7.3-apache-stretch

ENV COMPOSER_HOME /usr/bin/composer
WORKDIR /var/www/html

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
 curl \
 apt-transport-https \
 git \
 build-essential \
 libssl-dev \
 wget \
 vim \
 unzip \
 bzip2 \
 libbz2-dev \
 zlib1g-dev \
 mysql-client \
 libfontconfig \
 libfreetype6-dev \
 libjpeg62-turbo-dev \
 libicu-dev \
 libxml2-dev \
 libldap2-dev \
 libmcrypt-dev \
 python-pip \
 gnupg2 \
 apt-utils \
 cron \
 rsyslog \
 supervisor \
 jq \
 libzip-dev \
 && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# Install Node (with NPM)
#
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Composer
COPY --from=composer:latest $COMPOSER_HOME $COMPOSER_HOME

# Install additional php extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) \
      bcmath \
      bz2 \
      calendar \
      exif \
      ftp \
      gd \
      gettext \
      intl \
      ldap \
      mysqli \
      opcache \
      pcntl \
      pdo_mysql \
      shmop \
      soap \
      xml \
      mbstring \
      sockets \
      sysvmsg \
      sysvsem \
      sysvshm \
      zip \
    && pecl install redis apcu \
    && docker-php-ext-enable redis apcu \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt