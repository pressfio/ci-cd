.PHONY: FORCE
FORCE:

DEDICATED_REGISTRY    ?= ghcr.io
BUILDER_IMAGE_NAME    ?= pressf-builder
BUILDER_IMAGE_VERSION ?= 0.0.1

build: FORCE
	docker build \
		-t "${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}" \
		--pull=true \
		--network=host \
		--force-rm=true \
		--rm=true \
		--no-cache=true \
		.