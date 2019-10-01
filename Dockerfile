FROM php:7.3-fpm-alpine

# Add wait-for
ADD https://raw.githubusercontent.com/eficode/wait-for/master/wait-for /bin/wait-for.sh
RUN chmod +x /bin/wait-for.sh

# Add S6 supervisor (for graceful stop)
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.1.1/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /
ENTRYPOINT ["/init"]
CMD []

RUN apk update && apk add nginx
RUN docker-php-ext-install mysqli pdo_mysql

# Copy NGINX service script
COPY start-nginx.sh /etc/services.d/nginx/run
RUN chmod 755 /etc/services.d/nginx/run

# Copy PHP-FPM service script
COPY start-fpm.sh /etc/services.d/php_fpm/run
RUN chmod 755 /etc/services.d/php_fpm/run

COPY nginx.conf /etc/nginx/
