# Developer Documentation

This document describes how a developer can set up, build, launch, and manage the Inception project from scratch.

## 1. Setting Up the Environment
- **Prerequisites**: A Linux Virtual Machine with Docker and Docker Compose (v2) installed.
- **Configuration Files**:
  1. Ensure the `srcs/.env` file exists and contains non-sensitive variables:
     ```env
     DOMAIN_NAME=rsrour.42.fr
     MYSQL_DATABASE=maradb
     MYSQL_USER=maria_usr
     ```
  2. Create a `secrets/` directory at the **root** of the project (next to the `Makefile`).
  3. Create plain-text files for each required secret:
     - `secrets/db_root_password.txt`
     - `secrets/db_password.txt`
     - `secrets/wp_admin_password.txt`
  4. **Crucial**: Ensure the `secrets/` directory is listed in your `.gitignore` file to prevent accidental commits to Git.

## 2. Building and Launching
The project lifecycle is managed via the root `Makefile`, which wraps Docker Compose commands for consistency:
- `make` or `make all`: Builds the Docker images (if modified) and starts all containers in detached mode (`docker compose -f srcs/docker-compose.yml up -d --build`).
- `make clean`: Stops and removes containers and networks (`docker compose down`).
- `make fclean`: Executes `clean` and additionally removes named volumes (`docker compose down -v`).
- `make re`: Executes `fclean` followed immediately by `make all`.

## 3. Managing Containers and Volumes
Useful Docker commands for development and debugging:
- **List running containers**: `docker ps`
- **List all containers (including stopped)**: `docker ps -a`
- **Follow container logs**: `docker logs -f <container_name>`
- **Execute a shell inside a running container**: `docker exec -it <container_name> /bin/bash`
- **List all Docker volumes**: `docker volume ls`
- **Inspect a specific volume**: `docker volume inspect srcs_wp_data`

## 4. Data Storage and Persistence
Data persistence is handled by two Docker Named Volumes defined in `srcs/docker-compose.yml`:
- **`db_data`**: Mounted to `/var/lib/mysql` inside the `mariadb` container. Stores all database tables, users, and records.
- **`wp_data`**: Mounted to `/var/www/html` inside the `wordpress` container. Stores WordPress core files, themes, plugins, and media uploads.

These volumes persist data even if the containers are destroyed or recreated, as long as `make fclean` (or `docker compose down -v`) is **not** executed. In accordance with project requirements, these named volumes are configured to map their physical data to the `/home/<your_login>/data` directory on the host machine, ensuring data is not lost if the container is removed.