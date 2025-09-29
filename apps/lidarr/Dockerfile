# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1
ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV DOTNET_EnableDiagnostics=0 \
    LIDARR__UPDATE__BRANCH=plugins

USER root
WORKDIR /app

RUN \
    apk add --no-cache \
        chromaprint \
        ffmpeg \
        sqlite-libs \
    && mkdir -p /app/bin \
    && curl -fsSL "https://lidarr.servarr.com/v1/update/${LIDARR__UPDATE__BRANCH}/updatefile?version=${VERSION}&os=linuxmusl&runtime=netcore&arch=${TARGETARCH/amd64/x64}" \
        | tar xzf - -C /app/bin --strip-components=1 \
    && printf "UpdateMethod=docker\nBranch=%s\nPackageVersion=%s\nPackageAuthor=[%s](https://github.com/%s)\n" "${LIDARR__UPDATE__BRANCH}" "${VERSION}" "${VENDOR}" "${VENDOR}" > /app/package_info \
    && ln -s $(find /usr/bin -name ffprobe) /app/bin/ffprobe \
    && chown -R root:root /app && chmod -R 755 /app \
    && rm -rf /tmp/* /app/bin/Lidarr.Update /app/bin/fpcalc

COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

