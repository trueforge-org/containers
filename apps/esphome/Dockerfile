# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/python-alpine:3.12.11
ARG VERSION

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/ https://wheels.home-assistant.io/musllinux-index/"


ENV \
    HOME="/config" \
    PLATFORMIO_CORE_DIR=/cache/pio \
    ESPHOME_BUILD_PATH=/cache/build \
    ESPHOME_DATA_DIR=/cache/data

USER root
WORKDIR /app

RUN set -eux; \
    apk update; \
    apk add --no-cache \
        git \
        iputils \
        cairo \
        file \
        openssh-client \
        patch; \
    pip install uv; \
    uv pip install \
        setuptools \
        "esphome[displays]==${VERSION}"; \
    rm -rf /var/cache/apk/* /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config

CMD ["dashboard", "/config"]
