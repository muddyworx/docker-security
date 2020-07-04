include make_env

default: build

build: Dockerfile
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder

static-test: build
	@echo "Static analysis on Dockerfile..."
	@hadolint Dockerfile

generate: static-test
	@echo "Generating static site..."
	@docker run --rm --name=hugo $(VOLUMES) lp/hugo-builder hugo

start-server: generate
	@echo "Starting web server..."
	@docker run --rm -d --name=hugo $(VOLUMES) $(PORTS) lp/hugo-builder hugo server -w --bind=0.0.0.0

stop:
	@echo "Stopping Hugo-builder..."
	@docker container stop hugo

.PHONY: build generate start-server stop static-test
