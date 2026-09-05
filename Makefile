IMAGE_NAME ?= schemaforge-postgres-example
IMAGE_TAG ?= 0.1.0
RUNTIME_IMAGE ?= schemaforge-runtime:13.4.0
PLATFORM ?= linux/amd64
DOCKER ?= docker

.PHONY: build lint db-up db-down db-logs db-ps info validate migrate

build:
	$(DOCKER) build --platform $(PLATFORM) \
		--build-arg RUNTIME_IMAGE=$(RUNTIME_IMAGE) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) .

lint:
	./test/lint-migrations.sh

db-up:
	$(DOCKER) compose up -d postgres

db-down:
	$(DOCKER) compose down

db-logs:
	$(DOCKER) compose logs -f postgres

db-ps:
	$(DOCKER) compose ps

info validate migrate:
	@test -n "$(FLYWAY_URL)" || (echo "FLYWAY_URL is required" >&2; exit 1)
	@test -n "$(FLYWAY_USER)" || (echo "FLYWAY_USER is required" >&2; exit 1)
	@test -n "$(FLYWAY_PASSWORD)" || (echo "FLYWAY_PASSWORD is required" >&2; exit 1)
	$(DOCKER) run --rm --platform $(PLATFORM) \
		-e FLYWAY_URL -e FLYWAY_USER -e FLYWAY_PASSWORD \
		$(IMAGE_NAME):$(IMAGE_TAG) $@

