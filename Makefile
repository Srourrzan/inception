COMPOSE = docker compose -f srcs/docker-compose.yml

all: 
	$(COMPOSE) up -d --build

clean:
	$(COMPOSE) down

fclean:
	$(COMPOSE) down -v

re: fclean all