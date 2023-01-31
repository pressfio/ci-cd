FROM --platform=$BUILDPLATFORM debian:bullseye-slim

ARG BUILDPLATFORM
ARG BOT_SECRET
ENV PATH="${PATH}:/usr/local/go/bin"

RUN set -eu \
	&& apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y  \
		gcc \
		git \
		make \
		curl \
		tar \
		unzip

COPY content /builder
WORKDIR /builder

RUN set -eu; \
	BOT_SECRET=${BOT_SECRET} make bootstrap

ENTRYPOINT ["/bin/bash", "/builder/entrypoint.sh"]

CMD ["bash"]
