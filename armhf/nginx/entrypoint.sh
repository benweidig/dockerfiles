#!/bin/bash

if [ -n "${NGINX_USER}" ]; then
    sed -i "s/^user.*/user $NGINX_USER;/" /etc/nginx/nginx.conf
fi

if [ -n "${NGINX_WORKER_PROCESSES}" ]; then
    sed -i "s/^worker_processes.*/worker_processes $NGINX_WORKER_PROCESSES;/" /etc/nginx/nginx.conf
fi

if [ -n "${NGINX_WORKER_CONNECTIONS}" ]; then
    sed -i "s/^worker_connections.*/worker_connections $NGINX_WORKER_CONNECTIONS;/" /etc/nginx/nginx.conf
fi

if [ -n "${NGINX_ERROR_LOG_LEVEL}" ]; then
    sed -i "s/^error_log.*/error_log \/var\/log\/nginx\/error\.log $NGINX_ERROR_LOG_LEVEL;/" /etc/nginx/nginx.conf
fi

exec "$@"
