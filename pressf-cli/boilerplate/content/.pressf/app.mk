.PHONY: FORCE
FORCE:

# build section {{{
# Be careful with linebreak symbol '\'
define LDFLAGS
-X '$(GO_LD_APP_PKG).Name=$(PROJECT_NAME)' \
-X '$(GO_LD_APP_PKG).Version=$(APP_VERSION)' \
-X '$(GO_LD_APP_PKG).GitSha=$(GIT_SHA)' \
-X '$(GO_LD_APP_PKG).ReleaseAuthor=$(RELEASE_AUTHOR)' \
-X '$(GO_LD_APP_PKG).ReleaseTimestamp=$(RELEASE_TIMESTAMP)'
endef

build: FORCE 
	CGO_ENABLED=$(CGO_ENABLED) \
		go build \
			$(GO_BUILDFLAGS) \
			-ldflags="$(LDFLAGS)" \
			$|
# }}}

generate: FORCE
	go generate ./...

generate_common_types: FORCE
	protoc -I protobuf/common \
		--go_out=$(PROJECT_DIR) \
        --go_opt=paths=import \
        protobuf/common/*.proto 
		
generate_api: FORCE
	protoc -I api/ \
		--go_out=$(PROJECT_DIR) \
      	--go_opt=paths=import \
		--go-grpc_out=$(PROJECT_DIR) \
      	--go-grpc_opt=paths=import,require_unimplemented_servers=false \
		api/*.proto 

	protoc -I api/ \
		--dart_out=grpc:api/stubs/dart/lib \
		api/*.proto \
		/usr/local/include/google/protobuf/*.proto