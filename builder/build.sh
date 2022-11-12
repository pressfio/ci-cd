#!/bin/bash

DEDICATED_REGISTRY="${DEDICATED_REGISTRY:-"ghcr.io"}"
BUILDER_IMAGE_NAME="${BUILDER_IMAGE_NAME:-"pressf-builder"}"
BUILDER_IMAGE_VERSION="0.0.1"
BUILDER_BASE_IMAGE_VERSION="${BUILDER_BASE_IMAGE_VERSION:-3.16.2}"

docker build \
  -t "${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}" \
  --pull=true \
  --network=host \
  --force-rm=true \
  --rm=true \
  --no-cache=true \
  .