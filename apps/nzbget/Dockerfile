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
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/ https://wheels.home-assistant.io/musllinux-index/" \
    UV_INDEX_STRATEGY="unsafe-best-match"


ENV NZBGET__PORT=6789

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        7zip \
        lscpu \
    && \
    curl -fsSL -o /tmp/nzbget.run \
        "https://github.com/nzbgetcom/nzbget/releases/download/v${VERSION}/nzbget-${VERSION}-bin-linux.run" \
    && \
    sh /tmp/nzbget.run --destdir /app \
    && rm -rf /app/7za /app/unrar /app/unrar7 \
    && pip install uv \
    && uv pip install apprise pynzb requests \
    && chown -R root:root /app && chmod -R 755 /app \
    && pip uninstall --yes uv \
    && rm -rf /root/.cache /root/.cargo /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
