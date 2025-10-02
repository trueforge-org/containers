# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV DOTNET_EnableDiagnostics=0 \
    SONARR__UPDATE__BRANCH=develop

USER root
WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sqlite3 \
        curl \
        tar \
        ca-certificates && \
    mkdir -p /app/bin && \
    curl -fsSL "https://services.sonarr.tv/v1/update/${SONARR__UPDATE__BRANCH}/download?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${TARGETARCH/amd64/x64}" \
        | tar xzf - -C /app/bin --strip-components=1 && \
    printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[%s](https://github.com/%s)\n" \
        "${SONARR__UPDATE__BRANCH}" "${VERSION}" "${VENDOR}" "${VENDOR}" > /app/package_info && \
    chown -R root:root /app && chmod -R 755 /app && \
    rm -rf /var/lib/apt/lists/* /tmp/* /app/bin/Sonarr.Update

COPY . /

# Ensure non-root user exists
RUN groupadd -r nobody && useradd -r -g nobody nobody
USER nobody:nogroup
WORKDIR /config
