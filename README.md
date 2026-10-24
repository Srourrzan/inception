*This project has been created as part of the 42 curriculum by rsrour.*

## Description
Inception is a system administration project designed to introduce the concepts of virtualization and containerization using Docker. The goal is to set up a small, secure, and scalable infrastructure composed of multiple services (NGINX, WordPress + PHP-FPM, and MariaDB) running in isolated containers. These containers communicate via a dedicated Docker network and persist their data using Docker named volumes, all orchestrated by a `Makefile` and `docker-compose.yml`.

## Instructions
1. Clone this repository to your Virtual Machine.
2. Ensure Docker and Docker Compose are installed on your system.
3. Configure the `srcs/.env` file with your domain name and non-sensitive variables.
4. Create the `secrets/` directory at the project root and populate it with the required password files (`db_root_password.txt`, `db_password.txt`, `wp_admin_password.txt`).
5. Run `make` at the root of the project to build and start all services.
6. Add `127.0.0.1 rsrour.42.fr` to your host machine's `/etc/hosts` file.
7. Access the website securely at `https://rsrour.42.fr` (accept the self-signed certificate warning).

## Resources
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- **AI Usage**: AI was utilized to assist in drafting boilerplate configurations, debugging Docker networking issues (e.g., resolving container DNS race conditions during startup), and refining shell scripts for idempotency. All AI-generated code was thoroughly reviewed, tested, and fully understood before integration, adhering to 42's ethical AI guidelines.

## Project Description & Design Choices
This project relies on `debian:bookworm` as the base image for all containers to ensure stability, security, and access to up-to-date packages. The infrastructure is orchestrated using `docker-compose.yml` and a `Makefile` for streamlined lifecycle management. NGINX acts as the sole entry point, enforcing TLSv1.2/TLSv1.3 and redirecting all HTTP traffic to HTTPS.

### Technical Comparisons
- **Virtual Machines vs Docker**: VMs virtualize the entire hardware stack, including a full guest OS, making them heavy and slow to boot. Docker containers virtualize the OS layer, sharing the host kernel. This makes containers lightweight, fast to start, and highly efficient in resource usage.
- **Secrets vs Environment Variables**: Environment variables are suitable for non-sensitive configuration (e.g., domain names, ports). However, they can be exposed in process lists, logs, or container inspection outputs. Docker Secrets are specifically designed for sensitive data (passwords, API keys), storing them encrypted in memory and mounting them as read-only files (`/run/secrets/`), preventing accidental exposure in Git or logs.
- **Docker Network vs Host Network**: The Host network removes network isolation, binding container ports directly to the host, which can cause port conflicts and security risks. A custom Docker Network provides isolated, secure communication between containers using internal DNS resolution, while only exposing strictly necessary ports to the outside world.
- **Docker Volumes vs Bind Mounts**: Bind mounts depend on the host machine's specific directory structure, making them less portable and prone to permission issues. Docker Named Volumes are managed entirely by Docker, ensuring better performance, easier backups, and true portability across different host environments, while still guaranteeing data persistence outside the container lifecycle.