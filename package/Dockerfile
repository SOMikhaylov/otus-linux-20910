FROM alpine:3.11
RUN apk update && \
    apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers curl gnupg libxslt-dev gd-dev geoip-dev && \
    wget http://nginx.org/download/nginx-1.16.1.tar.gz && tar -xvf nginx-1.16.1.tar.gz && \
    wget https://www.openssl.org/source/openssl-1.1.1d.tar.gz && tar xzvf openssl-1.1.1d.tar.gz && \
    cd nginx-1.16.1 && \
    ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --pid-path=/var/run/nginx/pid --with-openssl=../openssl-1.1.1d && \
    make && make install

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

