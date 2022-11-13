.PHONY: FORCE
FORCE:

LOCAL_DIR := /usr/local
BIN_DIR   := $(LOCAL_DIR)/bin
TMP_DIR   := /tmp

GO             := $(LOCAL_DIR)/go/bin/go
PROTOC         := $(BIN_DIR)/protoc
DART         := $(BIN_DIR)/dart
CURL           := curl --location --fail --silent --create-dirs --output
KERNEL_VERSION := $(shell uname -s | tr A-Z a-z;)
ARCH_VERSION   := $(shell uname -m;)

# https://golang.org/doc/go-get-install-deprecation
GO_INSTALL = GOBIN=$(BIN_DIR) $(GO) install
GO_GET     = GO111MODULE=on GOBIN=$(BIN_DIR) $(GO) get

#lang versions {{{
GO_VERSION   ?= 1.19.3
DART_VERSION ?= 2.18.4
# }}}

# toolset versions {{{
GOLANGCI_LINT_VERSION     := 1.50.1
GOIMPORTS_VERSION         := 0.1.10
PROTOLINT_VERSION         := 0.41.0
MOCKGEN_VERSION           := 1.6.0
PROTOC_VERSION			  := 21.9
PROTOCGEN_GO_VERSION      := 1.28.0
PROTOCGEN_GO_GRPC_VERSION := 1.2.0
# }}}

# golangci-lint {{{
# https://github.com/golangci/golangci-lint
GOLANGCI_LINT                    := $(BIN_DIR)/golangci-lint
$(GOLANGCI_LINT): GO_CMD_URL     := github.com/golangci/golangci-lint/cmd/golangci-lint
$(GOLANGCI_LINT): GO_CMD_VERSION := $(GOLANGCI_LINT_VERSION)
GO_TOOLSET                       += $(GOLANGCI_LINT)
# }}}

# protoc-gen-go {{{
# https://pkg.go.dev/google.golang.org/protobuf
PROTOCGEN_GO                    :=  $(BIN_DIR)/protoc-gen-go
$(PROTOCGEN_GO): GO_CMD_URL     := google.golang.org/protobuf/cmd/protoc-gen-go
$(PROTOCGEN_GO): GO_CMD_VERSION := $(PROTOCGEN_GO_VERSION)
GO_TOOLSET                      += $(PROTOCGEN_GO)
# }}}

# protoc-gen-go-grpc {{{
# https://pkg.go.dev/google.golang.org/grpc/cmd/protoc-gen-go-grpc
PROTOCGEN_GO_GRPC                    :=  $(BIN_DIR)/protoc-gen-go-grpc
$(PROTOCGEN_GO_GRPC): GO_CMD_URL     := google.golang.org/grpc/cmd/protoc-gen-go-grpc
$(PROTOCGEN_GO_GRPC): GO_CMD_VERSION := $(PROTOCGEN_GO_GRPC_VERSION)
GO_TOOLSET                           += $(PROTOCGEN_GO_GRPC)
# }}}

# mockgen {{{
# https://github.com/golang/mock
MOCKGEN                    :=  $(BIN_DIR)/mockgen
$(MOCKGEN): GO_CMD_URL     := github.com/golang/mock/mockgen
$(MOCKGEN): GO_CMD_VERSION := $(MOCKGEN_VERSION)
GO_TOOLSET                 += $(MOCKGEN)
# }}}

UID := $(shell id -u;)
ifneq '$(UID)' '0'
	SUDO := sudo
endif

# golang -> install {{{
GO_SRC_URL   := https://dl.google.com/go/go$(GO_VERSION).$(KERNEL_VERSION)-amd64.tar.gz
GO_SRC_TAR   := $(TMP_DIR)/go.tar.gz

$(GO):
	$(SUDO) $(CURL) $(GO_SRC_TAR) $(GO_SRC_URL)
	$(SUDO) tar --extract --gzip --file $(GO_SRC_TAR) -C $(LOCAL_DIR)
	$(SUDO) rm -f $(GO_SRC_TAR)
	$(SUDO) go version
# }}}

# dart -> install {{{
ifeq '$(KERNEL_VERSION)' 'darwin'
$(DART): KERNEL_VERSION := macos
endif

ifeq '$(ARCH_VERSION)' 'x86_64'
$(DART): ARCH_VERSION := x64
endif

DART_SRC_URL = https://storage.googleapis.com/dart-archive/channels/stable/release/$(DART_VERSION)/sdk/dartsdk-$(KERNEL_VERSION)-$(ARCH_VERSION)-release.zip
DART_SRC_ZIP   := $(TMP_DIR)/dart.zip

$(DART):
	$(SUDO) $(CURL) $(DART_SRC_ZIP) $(DART_SRC_URL)
	$(SUDO) unzip -o $(DART_SRC_ZIP) -d $(TMP_DIR)/dart
	$(SUDO) cp -r $(TMP_DIR)/dart/dart-sdk/* $(LOCAL_DIR)
	$(SUDO) rm -rf  ${DART_SRC_ZIP} $(TMP_DIR)/dart
	$(SUDO) dart --version
	$(SUDO) dart pub global activate protoc_plugin
# }}}

# protoc -> install {{{
ifeq '$(KERNEL_VERSION)' 'darwin'
$(PROTOC): KERNEL_VERSION := osx
endif

PROTOC_URL       = https://github.com/protocolbuffers/protobuf/releases/download/v$(PROTOC_VERSION)/protoc-$(PROTOC_VERSION)-$(KERNEL_VERSION)-$(ARCH_VERSION).zip
PROTOC_SRC_ZIP   := $(TMP_DIR)/protoc.zip 

$(PROTOC):
	$(SUDO) $(CURL) $(PROTOC_SRC_ZIP) $(PROTOC_URL)
	$(SUDO) unzip -o $(PROTOC_SRC_ZIP) -d /usr/local bin/protoc
	$(SUDO) unzip -o $(PROTOC_SRC_ZIP) -d /usr/local 'include/*'
	$(SUDO) rm -f ${PROTOC_SRC_ZIP}
	$(SUDO) protoc --version
# }}}

common_lib: FORCE
	git clone \
		--quiet \
		--no-checkout \
		https://pressfio-bot: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@github.com/pressfio/go-common-lib.git \
		/usr/local/include/go-common-lib
	cd /usr/local/include/go-common-lib \
		&& git sparse-checkout init --cone \
		&& git sparse-checkout set protobuf/common \
		&& git checkout

$(GO_TOOLSET):
	$(GO_INSTALL) $(GO_CMD_PATH) $(GO_CMD_URL)@v$(GO_CMD_VERSION)

go: FORCE $(GO)
dart: FORCE $(DART)
protoc: FORCE $(PROTOC)
toolset: FORCE $(GO_TOOLSET)
bootstrap: FORCE go dart protoc common_lib toolset clean
clean: FORCE
	$(GO) clean -modcache -cache -fuzzcache -testcache


