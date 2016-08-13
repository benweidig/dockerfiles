# ARMHF/NGINX

A simple Dockerfile for building a [nginx](https://www.nginx.org) container with compile options.

You can set some nginx options via environment variables at container start


## Build Arguments

| Argument                 | Default                                                                           | Description                            |
| -------------------------| --------------------------------------------------------------------------------- | -------------------------------------- |
| NGINX_CONFIGURE_OPTIONS  | --with-ipv6 --with-http_ssl_module --with-pcre-jit --with-http_stub_status_module | ./configure options for building nginx |
| -------------------------| --------------------------------------------------------------------------------- | -------------------------------------- |


## Exposed ports

80 and 443


## Volumes

- /etc/nginx/sites-enabled


## Configure at startup time

You can set some options in the nginx.conf via environment variables:

- NGINX_USER
- NGINX_WORKER_PROCESSES
- NGINX_WORKER_CONNECTIONS
- NGINX_ERROR_LOG_LEVEL


## Run the container

First make sure we have the correct directory structure or docker will create directories belonging to root:

```
mkdir -p ~/nginx/sites-enabled
```

Then you can start the container. We link localtime/timezone directly from the host so the container has the same date/time as the host.
This is just an example, see

```
docker run \
    -d \
    --name nginx \
    -p 80:80 \
    -v ~/nginx/sites-enabled:/etc/nginx/sites-enabled \
    -v /etc/localtime:/etc/localtime:ro \
    -v /etc/timezone:/etc/timezone:ro \
    -e NGINX_USER=root \
    -e NGINX_WORKER_PROCESSES=2 \
    -e NGINX_WORKER_CONNECTIONS=2048 \
    armhf/nginx
```


## Logs

The access and error log are linked to stdout/stderr.
