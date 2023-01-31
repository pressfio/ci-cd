# https://www.gnu.org/software/make/manual/html_node/Variables_002fRecursion.html
.EXPORT_ALL_VARIABLES:

PROJECT_DIR               ?= $(CURDIR)
PROJECT_PRESSF_DIR        ?= $(PROJECT_DIR)/.pressf
PROJECT_DOCKER_DIR        ?= $(PROJECT_PRESSF_DIR)/docker
PROJECT_DOCKER_STANDS_DIR ?= $(PROJECT_DOCKER_DIR)/stands

# DEDICATED_REGISTRY variables {{{
DEDICATED_REGISTRY       ?= ghcr.io
DEDICATED_REGISTRY_OWNER ?= pressfio
# }}}

# BUILDER variables {{{
BUILDER_IMAGE_NAME    ?= pressfio/builder
BUILDER_IMAGE_VERSION ?= 0.0.2
BUILDER_PLATFORM	  ?= linux/amd64
BUILDER_IMAGE         := ${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}
# }}}

# BUILD variables {{{
GO_LD_APP_PKG := github.com/pressfio/go-common-lib/app/info/fields
GO_BUILDFLAGS ?= -mod=vendor -o=/tmp/app
CGO_ENABLED   ?= 0
TARGET_ARCH   ?= amd64
TARGET_OS	  ?= linux
# }}}

# GIT variables {{{
GIT_SHA       := $(shell git rev-parse HEAD;)
GIT_SHORT_SHA := $(shell git rev-parse --short=8 HEAD;)
GIT_BRANCH    := $(shell git symbolic-ref -q --short HEAD;)
GIT_TAG       := $(shell git describe --tags --exact-match 2> /dev/null;)
# }}}

# INFO variables {{{
PROJECT_NAME      := $(shell basename `git rev-parse --show-toplevel;`)
RELEASE_AUTHOR    := $(shell echo "`git config user.Name` <`git config user.email`>";)
RELEASE_TIMESTAMP := $(shell date +'%Y-%m-%dT%H:%M:%S%z';)
APP_VERSION       := $(GIT_TAG)
# }}}

# This is trick to let subst with space work properly
SPACE := $(NOTHING) $(NOTHING)

shell: FORCE 
	docker run \
		--network=host \
		--interactive \
		--tty \
		--rm \
		--volume /var/run/docker.sock:/var/run/docker.sock \
		--volume ${PROJECT_DIR}:/app:delegated \
		--workdir /app \
		--platform=${BUILDER_PLATFORM} \
		${DEDICATED_REGISTRY}/${BUILDER_IMAGE_NAME}:${BUILDER_IMAGE_VERSION}
