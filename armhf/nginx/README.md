# Armhf Nginx

A simple Dockerfile for building a [nginx](https://www.nginx.org) container with some configuration points.

The container will run as a custom user so you can match USERID/GROUPID for nicer file-ownership in volumes.

## Build Arguments

| Argument                 | Default | Description                                                |
| -------------------------| ------- | ---------------------------------------------------------- |
| NGINX_CONFIGURE_OPTIONS  | --with-ipv6 --with-pcre-jit --with-http_stub_status_module | ./configure options for building nginx |
| NGINX_WORKER_PROCESSES   | 1       | Defines the number of CPU cores used                       |
| NGINX_WORKER_CONNECTIONS | 1024    | Max number of simultaneous connections by a worker process |


## Exposed ports

80 and 443


## Volumes

- /etc/nginx/sites-enabled


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
    armhf/nginx
```

## Todo

Move the build args for nginx configuration to an entrypoint-script with environment variables
for niceer configuration of existing containers
