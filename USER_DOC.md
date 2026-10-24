# User Documentation

This document explains how an end user or administrator can interact with and manage the Inception infrastructure.

## 1. Services Provided
This stack provides a fully functional, secure web hosting environment:
- **NGINX**: Acts as the reverse proxy and web server. It is the only entry point to the infrastructure, handling all incoming HTTPS (port 443) traffic and automatically redirecting HTTP (port 80) to HTTPS.
- **WordPress + PHP-FPM**: The content management system that processes PHP and serves the dynamic website content.
- **MariaDB**: The relational database management system that securely stores all WordPress data (users, posts, settings, etc.).

## 2. Starting and Stopping the Project
Navigate to the root directory of the project and use the provided `Makefile`:
- **Start the project**: `make` or `make all` (Builds images and starts containers in the background).
- **Stop the project**: `make clean` (Stops and removes containers and networks, but **keeps your data safe**).
- **Wipe the project**: `make fclean` (Stops containers and **deletes all persistent data/volumes**).
- **Rebuild from scratch**: `make re` (Executes `fclean` followed by `all`).

## 3. Accessing the Website and Administration Panel
1. Ensure your host machine's `/etc/hosts` file contains the line: `127.0.0.1 rsrour.42.fr`
2. **Public Website**: Open your browser and navigate to `https://rsrour.42.fr`. *(Note: You will see a browser warning about the connection not being private. This is expected and safe, as the project uses a self-signed TLS certificate. Click "Advanced" -> "Accept the Risk and Continue")*.
3. **Administration Panel**: Navigate to `https://rsrour.42.fr/wp-admin` and log in with your administrator credentials.

## 4. Locating and Managing Credentials
- **Database & Admin Passwords**: Stored securely in the `secrets/` directory at the root of the project (e.g., `secrets/db_root_password.txt`, `secrets/wp_admin_password.txt`). These files are explicitly ignored by Git to prevent public exposure.
- **WordPress Admin User**: The default administrator username is configured during initialization (e.g., `srour`), and the password is defined in `secrets/wp_admin_password.txt`.

## 5. Checking Service Status
To verify that all services are running correctly, execute the following command in your terminal:
```bash
docker ps
```