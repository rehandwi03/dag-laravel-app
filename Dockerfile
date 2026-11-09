FROM php:8.2-apache

ENV APACHE_DOCUMENT_ROOT=/var/www/html/public \
    COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      unzip \
      libcurl4-openssl-dev \
      libicu-dev \
      libzip-dev \
      libonig-dev \
      libxml2-dev \
    && docker-php-ext-install -j"$(nproc)" \
      bcmath \
      curl \
      exif \
      intl \
      mbstring \
      opcache \
      pdo_mysql \
      zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer
COPY backend.apache.conf /etc/apache2/sites-available/000-default.conf

WORKDIR /var/www/html

COPY . .
RUN composer install \
      --no-dev \
      --no-interaction \
      --no-progress \
      --prefer-dist \
      --optimize-autoloader \
    && mkdir -p storage/framework/cache/data storage/framework/sessions storage/framework/views storage/logs bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache

EXPOSE 80

CMD ["apache2-foreground"]
