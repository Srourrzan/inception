#!/bin/bash

SSL_DIR="/etc/nginx/ssl"
CERT_FILE="$SSL_DIR/${DOMAIN_NAME}.crt"
KEY_FILE="$SSL_DIR/${DOMAIN_NAME}.key"

mkdir -p "$SSL_DIR"

if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
	echo "Certificates not found. Generating self-signed TLS certificates..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$KEY_FILE" \
        -out "$CERT_FILE" \
        -subj "/CN=${DOMAIN_NAME}"
else
    echo "Certificates already exist. Skipping generation."
fi

# Use envsubst to replace ${DOMAIN_NAME} in template config and create a real config file
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Waiting for WordPress to be reachable on the network..."
RETRIES=15
while [ $RETRIES -gt 0 ]; do
	if getent hosts wordpress > /dev/null; then
		echo "WordPress is reachable!"
		break
	fi
	echo "WordPress host not found yet - sleeping for 2 seconds"
	sleep 2
	RETRIES=$((RETRIES - 1))
done
if [ $RETRIES -eq 0 ]; then
	echo "Error: WordPress host never became reachable .."
	echo "check if 'wordpress' container is running"
	exit 1
fi

echo "Starting NGINX...."
exec nginx -g "daemon off;"
