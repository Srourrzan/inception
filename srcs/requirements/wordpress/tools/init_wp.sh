#!/bin/bash

# Read the secrets
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PASSWORD=$(cat /run/secrets/credentials)


# wait for mariaDB ro be ready
echo "waiting for mariaDB to be ready..."
until mariadb-admin ping -h mariadb -u root --password="$MYSQL_ROOT_PASSWORD" --silent >/dev/null 2>&1; do
	echo "MariaDB is unavailable - sleeping for 2 seconds"
	sleep 2
done

# check if wordpress is already installed
cd /var/www/html
if wp core is-installed --allow-root; then
	echo "wordPress is already installed. Skipping setup."
else
	echo "Installing wordPress."
	wp core download --allow-root
	wp config create --dbname="$MYSQL_DATABASE" --dbuser="$MYSQL_USER"  --dbpass="$MYSQL_PASSWORD" --dbhost="mariadb" --allow-root
	wp core install --url="https://$DOMAIN_NAME" --title="Inception" --admin_user="$ADMIN_USER" --admin_password="$ADMIN_PASSWORD" --admin_email="$ADMIN_USER@$DOMAIN_NAME" --allow-root
	echo "Installation complete"
fi



exec php-fpm8.2 -F
