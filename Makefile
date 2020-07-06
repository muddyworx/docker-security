include make_env

default: build

static-test: Dockerfile
	@echo "Static analysis on Dockerfile..."
	@echo "Running Hadolint..."
	@docker run --rm -i hadolint/hadolint:v1.17.5-alpine \
			hadolint --ignore DL3018 - < Dockerfile
	@echo "Hadolint passed."
	@echo "Running dockerfile_lint..."
	@docker run --rm -i -v $(PWD):/root/ projectatomic/dockerfile-lint \
			dockerfile_lint -f Dockerfile -r policies/additional_rules.yml
	@echo "dockerfile_lint passed."

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
