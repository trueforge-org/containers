# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04
ARG TARGETARCH
ARG VERSION

# Normalize architecture names
ARG TARGETARCH=${TARGETARCH/arm64/ARM64}
ARG TARGETARCH=${TARGETARCH/amd64/AMDx64}

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tar ca-certificates && \
    mkdir -p /app/bin && \
    curl -fsSL "https://github.com/Jackett/Jackett/releases/download/${VERSION}/Jackett.Binaries.LinuxMusl${TARGETARCH}.tar.gz" \
        | tar xzf - -C /app/bin --strip-components=1 && \
    chown -R root:root /app && chmod -R 755 /app && \
    rm -rf /var/lib/apt/lists/* /tmp/* /app/bin/JackettUpdater*

COPY . /

# Ensure non-root user exists
RUN groupadd -r nobody && useradd -r -g nobody nobody
USER nobody:nogroup
WORKDIR /config
