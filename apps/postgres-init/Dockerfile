# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1
ARG VERSION
USER root
RUN \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        postgresql17-client=="${VERSION}" \
    && rm -rf /tmp/*
COPY . /
USER nobody:nogroup
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
