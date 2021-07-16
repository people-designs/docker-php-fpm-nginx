FROM php:7.4-fpm-alpine3.13

# Add wait-for
ADD wait-for.sh /bin/wait-for.sh
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
RUN rm /etc/nginx/conf.d/default.conf
