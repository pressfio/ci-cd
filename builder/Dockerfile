FROM debian:bullseye-slim
ARG GO_VERSION

ENV PATH="${PATH}:/usr/local/go/bin"

RUN set -eu \
	&& apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y  \
		gcc \
		bash \
		git \
		make \
		curl \
		tar \
		unzip

COPY Makefile /Makefile
COPY entrypoint.sh /entrypoint.sh

RUN set -eu; \
	make bootstrap

ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]

CMD ["bash"]
