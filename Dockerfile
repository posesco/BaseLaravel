FROM alpine:3.17.2
RUN apk --no-cache add \
        zip \
        php81 \
        php81-fpm \
        php81-session \
        php81-dom \
        php81-intl \
        php81-mbstring \
        php81-curl \
        php81-xml \
        php81-zip \
        php81-mysqli \
        php81-pdo \
        php81-pdo_mysql \
        php81-gd \
        php81-phar \
        php81-tokenizer \
        nginx \
        runit \
        curl \
    && rm -rf /var/cache/apk/* \
    && chown -R nobody.nobody /run \
    && chown -R nobody.nobody /var/lib/nginx \
    && chown -R nobody.nobody /var/log/nginx
COPY --chown=nobody nginx/ /etc/nginx
COPY --chown=nobody php/ /etc/php81
COPY --chown=nobody service/ /etc/service
COPY --from=composer:2.5.4 /usr/bin/composer /usr/bin/composer
USER nobody
WORKDIR /var/www/html
COPY --chown=nobody laravel/ .
RUN composer install --ignore-platform-reqs --optimize-autoloader --no-interaction --no-progress
EXPOSE 80
CMD [ "/etc/service/docker-entrypoint.sh" ]