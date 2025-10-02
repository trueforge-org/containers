# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04
ARG VERSION

ENV DELUGE_BIN="deluged" \
    XDG_CONFIG_HOME="/config" \
    PYTHON_EGG_CACHE="/config/plugins/.python-eggs" \
    TMPDIR="/tmp"

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        p7zip-full \
        python3-future \
        python3-requests \
        python3-pip \
        curl \
        gzip \
        ca-certificates \
    && pip3 install "deluge==${VERSION}" \
    && pip3 install geoip2 \
    && mkdir -p /usr/share/GeoIP \
    && curl -fsSL "https://mailfud.org/geoip-legacy/GeoIP.dat.gz" \
        | gunzip > /usr/share/GeoIP/GeoIP.dat \
    && rm -rf /var/lib/apt/lists/* /tmp/*

COPY . /

# Copy unrar binary from LinuxServer image
COPY --from=ghcr.io/linuxserver/unrar:latest /usr/bin/unrar-alpine /usr/bin/unrar

# Switch to non-root user
RUN groupadd -r nobody && useradd -r -g nobody nobody
USER nobody:nogroup

WORKDIR /config
