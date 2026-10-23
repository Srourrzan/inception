#!/bin/bash

if [ ! -f /etc/nginx/ssl/ $DOMAIN_NAME.crt ]; then
openssl  req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/$DOMAIN_NAME.key \
        -out /etc/ss/certs/$DOMAIN_NAME.cert \
        -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=Student/CN=$DOMAIN_NAME"

else
    echo "Certificates already exist. Skipping generation."
fi
