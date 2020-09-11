dc=docker-compose $(1)
dc-run=$(call dc, run --service-ports --rm web $(1))

setup: build npm create_database
build: ## build docker image for development
	docker-compose build
npm: ## install_deps
	docker-compose run --rm web npm install
create_database: ## Creates database
	docker-compose run --rm web create_database.sh
dev:
	docker-compose run --rm web ash
up:
	docker-compose up
