# Project variables
BINARY_NAME=server
DOCKER_IMAGE=gmos
PORT=8080

# Default target
.PHONY: all
all: build

# --------------------------
# Go targets
# --------------------------

.PHONY: build
build:
	@echo "Building $(BINARY_NAME)..."
	go build -o $(BINARY_NAME) ./cmd/server

.PHONY: run
run:
	@echo "Running $(BINARY_NAME) locally..."
	go run ./cmd/server

.PHONY: clean
clean:
	@echo "Cleaning build artifacts..."
	@rm -f $(BINARY_NAME)

# --------------------------
# Docker targets
# --------------------------

.PHONY: docker-build
docker-build:
	@echo "Building Docker image $(DOCKER_IMAGE)..."
	docker build -t $(DOCKER_IMAGE) .

.PHONY: docker-run
docker-run:
	@echo "Running Docker container on port $(PORT)..."
	docker run --rm -p $(PORT):8080 $(DOCKER_IMAGE)

.PHONY: docker-clean
docker-clean:
	@echo "Removing Docker image $(DOCKER_IMAGE)..."
	docker rmi $(DOCKER_IMAGE)
