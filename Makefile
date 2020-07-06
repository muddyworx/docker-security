include make_env

default: build

static-test: Dockerfile
	@echo "Static analysis on Dockerfile..."
	@docker run --rm -i hadolint/hadolint:v1.17.5-alpine \
            hadolint --ignore DL3018 - < Dockerfile

build: static-test
	@echo "Building Hugo Builder container..."
	@docker build -t lp/hugo-builder .
	@echo "Hugo Builder container built!"
	@docker images lp/hugo-builder

generate: build
	@echo "Generating static site..."
	@docker run --rm --name=hugo $(VOLUMES) lp/hugo-builder hugo

start-server: generate
	@echo "Starting web server..."
	@docker run --rm -d --name=hugo $(VOLUMES) $(PORTS) lp/hugo-builder hugo server -w --bind=0.0.0.0

stop-server:
	@echo "Stopping Hugo-builder..."
	@docker container stop hugo

.PHONY: build generate start-server stop-server static-test
