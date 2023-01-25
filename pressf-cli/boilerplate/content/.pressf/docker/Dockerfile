ARG BUILDER_IMAGE

FROM ${BUILDER_IMAGE} as builder

# Tracing information about app.
ARG PROJECT_NAME
ARG APP_VERSION
ARG APP_GITSHA
ARG RELEASE_AUTHOR
ARG RELEASE_TIMESTAMP

ARG PROJECT_MOUNT_POINT
COPY ./ ${PROJECT_MOUNT_POINT}/
WORKDIR ${PROJECT_MOUNT_POINT}

RUN set -eu \
	&& make build \
		PROJECT_NAME="${PROJECT_NAME}" \
		APP_VERSION="${APP_VERSION}" \
		APP_GITSHA="${APP_GITSHA}" \
		RELEASE_AUTHOR="${RELEASE_AUTHOR}" \
		RELEASE_TIMESTAMP="${RELEASE_TIMESTAMP}" \
	&& test -x /tmp/app

FROM --platform=linux/amd64 scratch

# Tracing information about app.
ARG PROJECT_NAME
ARG APP_VERSION
ARG APP_GITSHA
ARG RELEASE_AUTHOR
ARG RELEASE_TIMESTAMP

LABEL pressf.maintainer='pressf-team'
LABEL pressf.builder-image="${BUILDER_IMAGE}"
LABEL pressf.app-name="${PROJECT_NAME}"
LABEL pressf.app-version="${APP_VERSION}"
LABEL pressf.app-git-sha="${APP_GITSHA}"
LABEL pressf.release-author="${RELEASE_AUTHOR}"
LABEL pressf.release-timestamp="${RELEASE_TIMESTAMP}"

COPY --from=builder /tmp/app /usr/local/bin/app
ENTRYPOINT ["/usr/local/bin/app"]