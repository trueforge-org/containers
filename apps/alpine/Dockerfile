# syntax=docker/dockerfile:1

ARG VERSION
FROM docker.io/library/alpine:${VERSION}@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

ENV XDG_CONFIG_HOME=/config \
    UMASK=0002

WORKDIR /app

# Install required packages
# hadolint ignore=DL3018
RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        icu-data-full \
        icu-libs \
        jq \
        libintl \
        nano \
        tzdata \
        grep \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

# Copy base-scripts files with correct ownership
COPY --chown=nobody:nogroup . /

# Switch to non-root user
USER nobody:nogroup

WORKDIR /config
VOLUME ["/config"]

# Start the container with catatonit as init
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
