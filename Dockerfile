#FROM dunglas/frankenphp:php8.4
#FROM dunglas/frankenphp:php8.4-alpine
FROM php:8.4-cli
#FROM php:8.4-fpm


#ENV SERVER_NAME=":80"
COPY . /var/www/franken-laravel

WORKDIR /var/www/franken-laravel

COPY --chown=www-data:www-data . /var/www/franken-laravel

# Install dependencies dan ekstensi yang diperlukan (PostgreSQL, MySQL, zip, pcntl)
RUN apt-get update && apt-get install -y \
    zip libzip-dev libpq-dev postgresql-client iputils-ping && \
    docker-php-ext-install pdo_pgsql pgsql pdo_mysql zip pcntl && \
    docker-php-ext-enable zip


COPY --from=composer:2.2 /usr/bin/composer /usr/bin/composer

RUN mkdir -p /var/www/franken-laravel/bootstrap/cache && chmod -R 775 /var/www/franken-laravel/bootstrap/cache
RUN mkdir -p /var/www/franken-laravel/storage && chmod -R 775 /var/www/franken-laravel/storage


RUN mkdir -p storage/framework/cache data storage/framework/sessions storage/framework/views
RUN chmod -R 775 /var/www/franken-laravel/storage

COPY .env.example /var/www/franken-laravel/.env

RUN composer install

RUN composer require laravel/octane

RUN php artisan octane:install --server=frankenphp

#RUN php artisan migrate

EXPOSE 8000

CMD php artisan octane:start --server=frankenphp --host=0.0.0.0 --port=8000
