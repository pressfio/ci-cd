.PHONY: FORCE
FORCE:

USE_BUILDX 			?= false
DOCKER_IMAGE        ?= $(DEDICATED_REGISTRY)/$(DEDICATED_REGISTRY_OWNER)/$(PROJECT_NAME):$(APP_VERSION)
PROJECT_MOUNT_POINT ?= /pressfio/project

docker_build: FORCE
ifeq '$(USE_BUILDX)' 'true'
$(BUILDX): --cache-to type=gha,mode=max --cache-from type=gha
$(GHA_CACHE): buildx
endif

	docker $(BUILDX) build \
		-f $(PROJECT_DOCKER_DIR)/Dockerfile \
		--tag $(DOCKER_IMAGE) \
		--build-arg 'TARGET_ARCH=$(TARGET_ARCH)' \
		--build-arg 'TARGET_OS=$(TARGET_OS)' \
		--build-arg 'BUILDER_IMAGE=$(BUILDER_IMAGE)' \
		--build-arg 'PROJECT_MOUNT_POINT=$(PROJECT_MOUNT_POINT)' \
		--build-arg 'PROJECT_NAME=$(PROJECT_NAME)' \
		--build-arg 'APP_VERSION=$(APP_VERSION)' \
		--build-arg 'APP_GITSHA=$(GIT_SHA)' \
		--build-arg 'RELEASE_AUTHOR=$(RELEASE_AUTHOR)' \
		--build-arg 'RELEASE_TIMESTAMP=$(RELEASE_TIMESTAMP)' \
		--platform $(TARGET_OS)/$(TARGET_ARCH) \
		$(GHA_CACHE) .

docker_build_amd64: TARGET_ARCH := amd64
docker_build_amd64: docker_build

docker_build_arm64: TARGET_ARCH := arm64
docker_build_arm64: docker_build

docker_push: FORCE
	docker push $(DOCKER_IMAGE)

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