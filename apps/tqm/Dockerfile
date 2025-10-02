# syntax=docker/dockerfile:1

FROM ubuntu:24.04
ARG TARGETARCH
ARG VERSION

USER root
WORKDIR /app

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        tar \
        ca-certificates && \
    mkdir -p /app/bin && \
    curl -fsSL "https://github.com/autobrr/tqm/releases/download/${VERSION}/tqm_${VERSION#*v}_linux_${TARGETARCH}.tar.gz" \
        | tar xzf - -C /app/bin && \
    chown -R root:root /app && chmod -R 755 /app && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY . /

# Ensure non-root user exists
RUN groupadd -r nobody && useradd -r -g nobody nobody
USER nobody:nogroup
WORKDIR /config
