FROM armhfbuild/debian:jessie
MAINTAINER Benjamin Weidig <ben@netzgut.net>

# ADDITIONAL CONFIGURE OPTIONS
ARG NGINX_CONFIGURE_OPTIONS="\
    --with-ipv6 \
    --with-http_ssl_module \
    --with-pcre-jit \
    --with-http_stub_status_module"
# Some other available modules
# --with-http_addition_module
# --with-http_dav_module
# --with-http_geoip_module
# --with-http_gzip_static_module
# --with-http_image_filter_module
# --with-http_spdy_module
# --with-http_sub_module
# --with-http_xslt_module
# --with-mail
# --with-mail_ssl_module
# --with-debug

# ADD NGINX TO APT
RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62
RUN echo "deb-src http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list

# UPDATE SYSTEM
RUN apt-get update \
    && apt-get -y upgrade

# BUILD DEPENDENCIES FOR NGINX
RUN apt-get -y build-dep nginx

# GET NGINX SOURCE, CONFIGURE AND BUILD
RUN apt-get source nginx \
    && cd nginx* \
    && ./configure $NGINX_CONFIGURE_OPTIONS \
    && dpkg-buildpackage -uc -b \
    && cd ..

# CLEANUP
RUN dpkg -i nginx*.deb \
    && rm -rf nginx*

# ADD OUR MODIFIED CONFIG
ADD nginx.conf /etc/nginx/nginx.conf

# DISABLE DEFAULT CONFIG
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.disabled

# LINK DEFAULT LOGS TO STDOUT/STDERR
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# GRANT ACCESS TO DEFAULT PORTS AND SET A VOLUME
EXPOSE 80 443
VOLUME ["/etc/nginx/sites-enabled"]

# ADD ENTRYPOINT, FIX PERMISSION
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
