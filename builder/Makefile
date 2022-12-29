.PHONY: FORCE
FORCE:

DEDICATED_REGISTRY    ?= ghcr.io
BUILDER_IMAGE_NAME    ?= pressf-builder
BUILDER_IMAGE_VERSION ?= 
BOT_SECRET            ?= 

build: FORCE
	docker build \
		-t "${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}" \
		--build-arg BOT_SECRET=$(BOT_SECRET) \
		--pull=true \
		--network=host \
		--force-rm=true \
		--rm=true \
		--no-cache=true \
		.
