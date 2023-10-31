NAME = inception
CONFIGS_FOLDER = ./srcs/requirements
COMPOSE_FILE = ./srcs/docker-compose.yml
ENV = ./srcs/.env
BASEYML = ./srcs/tools/base.yml
LOGIN = $(shell whoami)

all: build run

# Build the docker images in the docker-compose.yml file
build:
	mkdir -p ~/data/mariadb
	mkdir -p ~/data/wordpress
	sudo docker-compose -f $(COMPOSE_FILE) build
	@echo "\n\nInception is ready to be launched."

# Run the docker containers in the docker-compose.yml file
run:
	sudo docker-compose -f $(COMPOSE_FILE) up -d
	@echo "\n\nInception is now running on https://${LOGIN}.42.fr."

stop:
	sudo docker-compose -f $(COMPOSE_FILE) stop

# Launch the tests
test: build run

# Stop and remove the docker containers
clean: stop
	sudo docker-compose -f $(COMPOSE_FILE) down -v

# Remove the docker images
fclean: clean
	@if [ -n "$$(sudo docker ps -a -q)" ]; then sudo docker rm -f $$(sudo docker ps -a -q); fi
	@if [ -n "$$(sudo docker images -q)" ]; then sudo docker rmi -f $$(sudo docker images -q); fi
	@if [ -n "$$(sudo docker volume ls -q)" ]; then sudo docker volume prune -f; fi
	sudo rm -rf ~/data/*

re: fclean all
