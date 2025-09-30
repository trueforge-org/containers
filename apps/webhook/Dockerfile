# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/python-alpine:3.12.11
ARG TARGETARCH
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
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/ https://pypi.org/simple https://wheels.home-assistant.io/musllinux-index/" \
    UV_INDEX_STRATEGY="unsafe-best-match"


ENV \
    WEBHOOK__PORT="9000" \
    WEBHOOK__URLPREFIX="hooks"

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        jo \
        trurl \
    && mkdir -p /app/bin \
    && \
    curl -fsSL "https://github.com/adnanh/webhook/releases/download/${VERSION}/webhook-linux-${TARGETARCH}.tar.gz" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && \
    pip install uv \
    && uv pip install "apprise>=1, <2" \
    && chown -R root:root /app && chmod -R 755 /app \
    && pip uninstall --yes uv \
    && rm -rf /tmp/*

COPY . /

USER nobody:nogroup
WORKDIR /config
