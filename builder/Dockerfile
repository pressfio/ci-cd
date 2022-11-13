FROM debian:bullseye-slim
ARG GO_VERSION

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
	make bootstrap

ENTRYPOINT ["/bin/bash", "/builder/entrypoint.sh"]

CMD ["bash"]
