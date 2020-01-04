FROM alpine:3.11

RUN apk update && apk add php7 php7-fpm php7-opcache

EXPOSE 9000

CMD ["php-fpm7", "--nodaemonize"]