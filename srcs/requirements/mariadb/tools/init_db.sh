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

# Cleanup function
MARIADB_PID=""
cleanup() {
	if [ -n "$MARIADB_PID" ]; then
		echo "Cleaning up temporary MariaDB instance"
		mysqladmin -u root shutdown || true
		wait $MARIADB_PID || true
	fi
}

trap cleanup EXIT # This will call `cleanup` on all exit cases

# Read the secret file into a variable
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# Create socket bind directory
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql" ] || [ -z "$(ls -A /var/lib/mysql)" ]; then
# To populate mariaDB data 
    if mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql; then
	    echo "Success: mariaDB data dir wis populated."
    else
	    echo "Error: Failed to populate mariaDB data dir."
	    exit 1
    fi
fi

# Start MariaDB in background (temporary)
mariadbd --user=mysql &
MARIADB_PID=$!

# Wait for MariaDB to be ready to accept connnections
echo "Waiting for MariaDB to be ready ..."
for i in {30..0}; do
	if mysqladmin ping -u root --silent >/dev/null 2>&1; then
		echo "MariaDB is ready!"
		break
	fi
	echo "Waiting... ($i seconds left)"
	sleep 1
done

# If the loop finished and i is 0, MariaDB failed to start
if [ "$i" = 0 ]; then
	echo "Error: MariaDB failed to start within 30 seconds."
	exit 1
fi

# Run initialization SQL using heredoc
if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
	echo "Error: Missing required environment variabe"
	exit 1
fi

mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

cleanup
# Remove trap
trap - EXIT

# Start MariaDB DAEMON (server)
exec mariadbd --user=mysql
