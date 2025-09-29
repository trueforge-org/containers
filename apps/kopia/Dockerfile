# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1
ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/amd64/x64}
ARG VERSION

ENV \
    KOPIA_CHECK_FOR_UPDATES=false \
    KOPIA_CONFIG_PATH=/config/repository.config \
    KOPIA_CACHE_DIRECTORY=/config/cache \
    KOPIA_LOG_DIR=/config/logs \
    KOPIA_PERSIST_CREDENTIALS_ON_CONNECT=false

ENV \
    KOPIA_WEB_ENABLED=true \
    KOPIA_WEB_PORT=51515

USER root

RUN \
    curl -fsSL "https://github.com/kopia/kopia/releases/download/${VERSION}/kopia-${VERSION#*v}-linux-${TARGETARCH}.tar.gz" \
        | tar xzf - -C /usr/local/bin --strip-components 1 \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

