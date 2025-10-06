# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04
ARG TARGETARCH
ARG VERSION

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apk --no-cache add ca-certificates tzdata
RUN set -ex; \
	wget --quiet -O /tmp/traefik.tar.gz "https://github.com/traefik/traefik/releases/download/v${VERSION}/traefik_v${VERSION}_linux_${TARGETARCH}.tar.gz"; \
	tar xzvf /tmp/traefik.tar.gz -C /usr/local/bin traefik; \
	rm -f /tmp/traefik.tar.gz; \
	chmod +x /usr/local/bin/traefik
EXPOSE 80

USER nobody:nogroup

WORKDIR /config
CMD ["traefik"]
