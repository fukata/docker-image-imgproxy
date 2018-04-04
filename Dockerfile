FROM debian:stretch

ENV NGINX_VERISON=1.12.2

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    wget \
    openssl \
    libssl-dev \
    gettext \
    libpcre3 \
    libpcre3-dev \
    libxml2-dev \
    libxslt-dev \
    libgd-dev \
    libgeoip-dev \
    libimlib2-dev \
    libmagick++-dev \
    && git clone https://github.com/cubicdaiya/ngx_small_light.git /usr/local/src/ngx_small_light \
    && cd /usr/local/src/ngx_small_light \
    && ./setup --with-imlib2 --with-gd \
    && wget http://nginx.org/download/nginx-$NGINX_VERISON.tar.gz -O /usr/local/src/nginx-$NGINX_VERISON.tar.gz \
    && cd /usr/local/src/ \
    && tar zxf nginx-$NGINX_VERISON.tar.gz \
    && cd nginx-$NGINX_VERISON \
    && ./configure \
      --prefix=/etc/nginx \
      --conf-path=/etc/nginx/nginx.conf \
      --error-log-path=/var/log/nginx/error.log \
      --http-client-body-temp-path=/var/lib/nginx/body \
      --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
      --http-log-path=/var/log/nginx/access.log \
      --http-proxy-temp-path=/var/lib/nginx/proxy \
      --http-scgi-temp-path=/var/lib/nginx/scgi \
      --http-uwsgi-temp-path=/var/lib/nginx/uwsgi \
      --lock-path=/var/lock/nginx.lock \
      --pid-path=/var/run/nginx.pid \
      --with-debug \
      --with-http_addition_module \
      --with-http_dav_module \
      --with-http_geoip_module \
      --with-http_gzip_static_module \
      --with-http_image_filter_module \
      --with-http_realip_module \
      --with-http_stub_status_module \
      --with-http_ssl_module \
      --with-http_sub_module \
      --with-http_xslt_module \
      --with-ipv6 \
      --with-sha1=/usr/include/openssl \
      --with-md5=/usr/include/openssl \
      --with-mail --with-mail_ssl_module \
      --add-module=/usr/local/src/ngx_small_light \
    && make \
    && make install \
    && mkdir /var/lib/nginx \
    && mkdir /var/cache/imgproxy_cache

COPY nginx/nginx.conf.template /etc/nginx/nginx.conf.template

ENV DOLLAR='$'
ENV PROXY_CACHE_DIR='/var/cache/imgproxy_cache'
ENV PROXY_CACHE_LEVELS='1:2'
ENV PROXY_CACHE_MAX_SIZE='1G'
ENV PROXY_CACHE_INACTIVE='1h'
ENV PROXY_CACHE_ZONE_SIZE='5m'
ENV PROXY_CACHE_VALID_200='1h'
ENV S3_DIR_PREFIX='images/'
ENV URL_PREFIX='thumb/'

CMD bash -c "envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf && /etc/nginx/sbin/nginx -c /etc/nginx/nginx.conf"
