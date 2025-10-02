# syntax=docker/dockerfile:1

ARG VERSION
FROM docker.io/library/ubuntu:${VERSION}

ARG TARGETARCH
ARG VENDOR

ENV DEBIAN_FRONTEND="noninteractive" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility"

USER root
WORKDIR /app

# Install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        jq \
        nano \
        tzdata \
        uuid-runtime \
        xmlstarlet \
        libicu70 \
        libicu-dev \
        gettext-base \
        grep \
        tar \
        wget \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && update-ca-certificates \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

COPY . /

# Use a safe non-root user
USER nobody:nogroup

# Config directory (persistent volume)
VOLUME ["/config"]
WORKDIR /config

# PID 1 with catatonit, handoff to entrypoint
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
