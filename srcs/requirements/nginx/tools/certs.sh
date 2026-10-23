#!/bin/bash

mkdir -p /etc/nginx/ssl/private

if [ ! -f /etc/nginx/ssl/${DOMAIN_NAME}.crt ] || [ ! -f /etc/nginx/ssl/${DOMAIN_NAME}.key]; then
	echo "Certificates not found. Generating self-signed TLS certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/${DOMAIN_NAME}.key \
        -out /etc/ss/certs/${DOMAIN_NAME}.cert \
        -subj "/CN=${DOMAIN_NAME}"

else
    echo "Certificates already exist. Skipping generation."
fi

echo "Starting NGINX...."
exec nginx -g "daemon off;"
