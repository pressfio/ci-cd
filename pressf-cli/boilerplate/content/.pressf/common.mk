.PHONY: FORCE
FORCE:

PROJECT_DIR           ?= $(shell pwd;)
DEDICATED_REGISTRY    ?= ghcr.io
BUILDER_IMAGE_NAME    ?= pressf-builder
BUILDER_IMAGE_VERSION ?= 0.0.1

shell: FORCE 
	docker run \
		--network=host \
		--interactive \
		--tty \
		--rm \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		--volume ${PROJECT_DIR}:/app:delegated \
		--workdir /app \
		${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}
	
build: FORCE
	go build -o app

generate_common_types: FORCE
	protoc -I protobuf/common \
		--go_out=$(PROJECT_DIR) \
        --go_opt=paths=import \
        protobuf/common/*.proto 

generate_api: FORCE fetch_common_lib
	protoc -I api/ \
		--dart_out=grpc:api/stubs/dart/lib \
		--go_out=$(PROJECT_DIR) \
      	--go_opt=paths=import \
		--go-grpc_out=$(PROJECT_DIR) \
      	--go-grpc_opt=paths=import,require_unimplemented_servers=false \
		api/*.proto