# syntax=docker/dockerfile:1

ARG VERSION
FROM docker.io/library/ubuntu:${VERSION}

ARG TARGETARCH
ARG VENDOR

ENV DEBIAN_FRONTEND="noninteractive" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility" \
     # Enable detection of dotnet running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    XDG_CONFIG_HOME=/config

USER root
WORKDIR /app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        bash \
        ca-certificates \
        tini \
        coreutils \
        curl \
        jq \
        nano \
        tzdata \
        uuid-runtime \
        xmlstarlet \
        libicu-dev \
        gettext-base \
        grep \
        tar \
        wget \
        libssl3 \
        sed \
        software-properties-common \
        gnupg \
        dirmngr \
        xz-utils \
        locales \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && apt-get autoremove -y \
    && apt-get clean \
    && update-ca-certificates \
    && mkdir /cache \
    && chmod 777 /cache \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

# Use a safe non-root user
USER nobody:nogroup

COPY --chmod=0775 . /

RUN echo "show app and root folder content...";\
    ls -l / \
    && \
    ls -l /app

# Config directory (persistent volume)
VOLUME ["/config"]
WORKDIR /config

# PID 1 with tini, handoff to entrypoint
ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
