FROM alpine:3.23

RUN apk --no-cache add \
        php84 php84-cli php84-fpm php84-opcache \
        php84-openssl php84-curl php84-mbstring \
        php84-tokenizer php84-xml php84-xmlwriter \
        php84-xmlreader php84-ctype php84-fileinfo \
        php84-bcmath php84-pdo php84-pdo_mysql php84-iconv \
        php84-mysqli php84-session php84-dom \
        php84-intl php84-zip php84-gd php84-phar \
        nginx \
        runit \
        curl \
        git \
        nodejs \
        npm \
    && rm -rf /var/cache/apk/*
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN addgroup -g 1000 laravel && \
    adduser -D -u 1000 -G laravel laravel

RUN mkdir -p /var/www/html /run/php && \
    chown -R laravel:laravel /var/www/html /var/lib/nginx /var/log/nginx /run /tmp

COPY --chown=laravel:laravel nginx/ /etc/nginx/
COPY --chown=laravel:laravel php/ /etc/php84/
COPY --chown=laravel:laravel service/ /etc/service/

RUN chmod +x /etc/service/docker-entrypoint.sh \
             /etc/service/nginx/run \
             /etc/service/php/run

RUN curl -o /usr/local/bin/php-fpm-healthcheck \
    https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck \
    && chmod +x /usr/local/bin/php-fpm-healthcheck

USER laravel
WORKDIR /var/www/html

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
    CMD php-fpm-healthcheck || exit 1

CMD ["/etc/service/docker-entrypoint.sh"]