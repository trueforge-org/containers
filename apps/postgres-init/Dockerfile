# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1
ARG VERSION
USER root
RUN \
    apk add --no-cache \
        postgresql17-client=="${VERSION}" \
    && rm -rf /tmp/*
COPY . /
USER nobody:nogroup
