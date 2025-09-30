# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/python-alpine:3.12.11
ARG VERSION

ENV HOME="/config"

USER root
WORKDIR /app


RUN \
    apk add --no-cache --virtual=build-dependencies \
        build-base \
        curl-dev \
    && apk add --no-cache \
        ffmpeg \
        libatomic \
        libcurl \
        libjpeg-turbo \
        7zip \
        sqlite \
        tesseract-ocr \
    && pip install --no-cache-dir uv \
    && uv pip install --pre pyload-ng[all]=="${VERSION}" \
    && mkdir -p /config && chown nobody:nogroup -R /config \
    && mkdir -p /downloads && chown nobody:nogroup -R /downloads \
    && apk del --purge build-dependencies \
    && rm -rf /root/.cache /tmp/*

COPY . /

COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

USER nobody:nogroup
WORKDIR /config
