# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1
ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64/ARM64}
ARG TARGETARCH=${TARGETARCH/amd64/AMDx64}
ARG VERSION

USER root

RUN \
    mkdir -p /app/bin \
    && curl -fsSL "https://github.com/Jackett/Jackett/releases/download/${VERSION}/Jackett.Binaries.LinuxMusl${TARGETARCH}.tar.gz" \
        | tar xzf - -C /app/bin --strip-components 1 \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/* /app/bin/JackettUpdater*

COPY . /

USER nobody:nogroup
WORKDIR /config

