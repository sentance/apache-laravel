FROM php:7.2-apache

ENV APACHE_DOCROOT /var/www/html/public
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/www/html

#
# Install basic requirements
#
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
 mariadb-client \
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
 telnet \
 nano\
 imagemagick \
 jpegoptim \
 optipng \
 pngquant \
 gifsicle \
 libtool \

 && apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#
# Install Node (with NPM)
#
# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

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
      
    && pecl install redis apcu imagick \
    && docker-php-ext-enable redis apcu imagick \
    && pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt