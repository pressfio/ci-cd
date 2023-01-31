.PHONY: FORCE
FORCE:

DEDICATED_REGISTRY    ?= ghcr.io
BUILDER_IMAGE_NAME    ?= pressfio/builder
BUILDER_IMAGE_VERSION ?= $(shell git tag | grep builder | head -n 1 | sed -e 's/builder\///')
BUILDER_PLATFORM 	  ?= linux/amd64
BOT_SECRET            ?= 

build: FORCE
	docker buildx build \
		--tag="${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}" \
		--build-arg=BOT_SECRET=$(BOT_SECRET) \
		--pull=true \
		--network=host \
		--force-rm=true \
		--rm=true \
		--platform=$(BUILDER_PLATFORM) \
		.

push: FORCE
	docker push "${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}"
