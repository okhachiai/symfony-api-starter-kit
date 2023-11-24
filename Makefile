#!/bin/bash

OS = $(shell uname)
UID = $(shell id -u)
DOCKER_PHP = symfony-api-starter-kit-api_php-1
SYMFONY_CONSOLE = docker exec --user ${UID} ${DOCKER_PHP} sf

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

check: ## Check symfony requirements on the project
    U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_PHP} symfony check:requirements

init: ## Init the application for the first time
	U_ID=${UID} rm -rf app || true
	U_ID=${UID} docker-compose down || true
	U_ID=${UID} docker-compose build || true
	U_ID=${UID} docker-compose up -d || true
	U_ID=${UID} docker exec -it ${DOCKER_PHP} symfony new .
	cp -n .env.dist .env || true


install: ## Install the application
	cp .env.dist .env || true
	cp .env.dist .env.dev || true
	U_ID=${UID} docker-compose down || true
	U_ID=${UID} docker-compose build || true
	U_ID=${UID} docker-compose up -d || true


db-refresh: ## Refresh the database with fixtures data
    U_ID=${UID} ${SYMFONY_CONSOLE} doctrine:database:drop --force
    U_ID=${UID} ${SYMFONY_CONSOLE} doctrine:database:create

start: ## Start the containers
	cp -n .env.dist .env || true
	U_ID=${UID} docker-compose up -d || true

stop: ## Stop the containers
	U_ID=${UID} docker-compose stop

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start

build: ## Rebuilds all the containers
	docker network create api-network || true
	cp -n .env.dist .env || true
	U_ID=${UID} docker-compose build

prepare: ## Runs backend commands
	$(MAKE) composer-install
	$(MAKE) migrations

run: ## starts the Symfony development server
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_PHP} symfony serve -d

# Backend commands
composer-install: ## Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_PHP} composer install --no-interaction

composer-update: ## Update composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_PHP} composer update --no-interaction


migrations: ## Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_PHP} bin/console doctrine:migration:migrate -n --allow-no-migration

logs: ## Show Symfony logs in real time
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_PHP} symfony server:log
	
# End backend commands

bash: ## bash into the be container
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_PHP} bash

code-style: ## Runs php-cs to fix code styling following Symfony rules
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_PHP} php-cs-fixer fix src --rules=@Symfony
