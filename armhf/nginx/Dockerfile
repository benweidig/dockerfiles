FROM armhfbuild/debian:jessie
MAINTAINER Benjamin Weidig <ben@netzgut.net>

# ADDITIONAL CONFIGURE OPTIONS
ARG NGINX_CONFIGURE_OPTIONS="\
    --with-ipv6 \
    --with-pcre-jit \
    --with-http_stub_status_module"

# NGINX CONFIG
ARG NGINX_WORKER_PROCESSES=1
ARG NGINX_WORKER_CONNECTIONS=1024

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
    && ./configure --user=www-data --group=www-data --prefix=/usr/local/nginx $NGINX_CONFIGURE_OPTIONS \
    && dpkg-buildpackage -uc -b \
    && cd ..

# CLEANUP
RUN dpkg -i nginx*.deb \
    && rm -rf nginx*

# ADD OUR MODIFIED CONFIG
ADD nginx.conf /etc/nginx/nginx.conf

# DISABLE DEFAULT CONFIG
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.disabled

# CONFIGURE NGINX
RUN sed -i "s/^worker_processes.*/worker_processes $NGINX_WORKER_PROCESSES;/" /etc/nginx/nginx.conf \
    && sed -i "s/^.*worker_connections.*/worker_connections $NGINX_WORKER_CONNECTIONS;/" /etc/nginx/nginx.conf

# LINK DEFAULT LOGS TO STDOUT/STDERR
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# GRANT ACCESS TO DEFAULT PORTS
EXPOSE 80 443

VOLUME ["/etc/nginx/sites-enabled"]

# FINALLY RUN NGINX
CMD ["nginx", "-g", "daemon off;"]
