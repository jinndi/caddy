# https://hub.docker.com/_/alpine/tags
FROM alpine:3.23

# https://github.com/caddyserver/caddy/releases
ARG CADDY_VERSION=v2.11.3

RUN apk add --no-cache \
	ca-certificates \
	curl \
	libcap \
	mailcap \
  bash

RUN set -eux; \
	mkdir -p \
		/config/caddy \
		/data/caddy \
		/etc/caddy

ENV CADDY_VERSION=${CADDY_VERSION}

# Copy scripts to container
COPY ./entrypoint.sh /entrypoint.sh

RUN set -eux; \
	apkArch="$(apk --print-arch)"; \
	case "$apkArch" in \
		x86_64)  binArch='amd64'; checksum='ee886eceda0ff9f30610d3be9b5b594026591e19add6b3961a341c72abe468e5eac9d7c2c2450bbb8420db1f827b954521f9336be4872f81090b8618adf8815a' ;; \
		aarch64) binArch='arm64'; checksum='bd06996e1612cf5e9770dc7134313067ef3fdfde43b1a2196004906006de779372dcf7a0e7c7fb0890c23791179f12be4625f1b6e666a2abf37e8aff4c3a1826' ;; \
		*) echo >&2 "error: unsupported architecture ($apkArch)"; exit 1 ;;\
	esac; \
	wget -O /tmp/caddy.tar.gz "https://github.com/caddyserver/caddy/releases/download/${CADDY_VERSION}/caddy_${CADDY_VERSION#v}_linux_${binArch}.tar.gz"; \
	echo "$checksum  /tmp/caddy.tar.gz" | sha512sum -c; \
	tar x -z -f /tmp/caddy.tar.gz -C /usr/bin caddy; \
	rm -f /tmp/caddy.tar.gz; \
	setcap cap_net_bind_service=+ep /usr/bin/caddy; \
	chmod +x /usr/bin/caddy /entrypoint.sh; \
	caddy version

# See https://caddyserver.com/docs/conventions#file-locations for details
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

LABEL org.opencontainers.image.version=${CADDY_VERSION}
LABEL org.opencontainers.image.title=Caddy
LABEL org.opencontainers.image.description="a powerful, enterprise-ready, open source web server with automatic HTTPS written in Go"
LABEL org.opencontainers.image.url=https://caddyserver.com
LABEL org.opencontainers.image.documentation=https://caddyserver.com/docs
LABEL org.opencontainers.image.vendor="Light Code Labs"
LABEL org.opencontainers.image.licenses=Apache-2.0
LABEL org.opencontainers.image.source="https://github.com/caddyserver/caddy-docker"
LABEL maintainer="Jinndi <alncores@gmail.com>"

EXPOSE 80
EXPOSE 443
EXPOSE 443/udp
EXPOSE 2019

WORKDIR /srv

ENTRYPOINT ["/entrypoint.sh"]
