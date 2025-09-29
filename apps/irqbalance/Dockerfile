# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1
ARG VERSION
USER root
RUN \
    apk add --no-cache \
        irqbalance=="${VERSION}" \
    && rm -rf /tmp/*
ENTRYPOINT ["/usr/sbin/irqbalance", "--foreground"]
