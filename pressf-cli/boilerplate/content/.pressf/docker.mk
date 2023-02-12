.PHONY: FORCE
FORCE:

DOCKER_IMAGE        ?= $(DEDICATED_REGISTRY)/$(DEDICATED_REGISTRY_OWNER)/$(PROJECT_NAME):$(APP_VERSION)
PROJECT_MOUNT_POINT ?= /pressfio/project

BUILDX_FLAGS := 
ifdef USE_GHA_CACHE
BUILDX_FLAGS += --cache-to type=gha,mode=max --cache-from type=gha
endif

ifdef PUBLISH_AFTER_BUILD
BUILDX_FLAGS += --push
endif

docker_build: FORCE
	docker buildx build \
		-f $(PROJECT_DOCKER_DIR)/Dockerfile \
		--tag $(DOCKER_IMAGE) \
		--build-arg 'RUNNER_IMAGE=$(RUNNER_IMAGE)' \
		--build-arg 'BUILDER_IMAGE=$(BUILDER_IMAGE)' \
		--build-arg 'PROJECT_MOUNT_POINT=$(PROJECT_MOUNT_POINT)' \
		--build-arg 'PROJECT_NAME=$(PROJECT_NAME)' \
		--build-arg 'APP_VERSION=$(APP_VERSION)' \
		--build-arg 'APP_GITSHA=$(GIT_SHA)' \
		--build-arg 'RELEASE_AUTHOR=$(RELEASE_AUTHOR)' \
		--build-arg 'RELEASE_TIMESTAMP=$(RELEASE_TIMESTAMP)' \
		--platform=${BUILDER_PLATFORM} \
		$(BUILDX_FLAGS) .

define REQUIRE_STANDS
	@echo 'STANDS must be defined as non-empty'
	@exit 1
endef

STANDS_COMPOSE_FILES := $(foreach STAND,$(STANDS),$(PROJECT_DOCKER_STANDS_DIR)/$(STAND)/docker-compose.yml)
ifdef MAKE_LOCALLY
STANDS_COMPOSE_FILES += $(foreach STAND,$(STANDS),$(PROJECT_DOCKER_STANDS_DIR)/$(STAND)/docker-compose.local.yml)
endif

stand_up: COMPOSE_ARGS := --remove-orphans --detach --build
stand_down: COMPOSE_ARGS := --remove-orphans --volumes

stand_%: COMPOSE_ARGS ?=
stand_%: COMPOSE_CMD ?= $*
stand_%: FORCE | $(STANDS_COMPOSE_FILES)
ifdef STANDS
	COMPOSE_PROJECT_NAME=$(PROJECT_NAME) \
	COMPOSE_FILE='$(subst $(SPACE),:,$|)' \
		docker-compose $(COMPOSE_CMD) $(COMPOSE_ARGS)
else
	$(REQUIRE_STANDS)
endif