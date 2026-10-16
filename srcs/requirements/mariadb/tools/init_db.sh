#!/bin/bash

# 1. Start MariaDB in background (temporary)
# 2. Wait until it accepts connections (with a loop - this is OK because it has an exit condition)
# 3. Run initialization SQL:
# - CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE
# - CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'
# - GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%'
# - (Optional) Set root password
# - FLUSH PRIVILEGES
# 4. Stop the temporary MariaDB cleanly
# 5. Start MariaDB in FOREGROUND using `exec` (this replaces the shell with MariaDB as PID 1)

# To populate mariaDB data dir
if mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql; then
	echo "Success: mariaDB data dir wis populated."
else
	echo "Error: Failed to populate mariaDB data dir."
	exit 1
fi

# Start MariaDB
exec mariadb --user=mysql
