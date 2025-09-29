FROM alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

ENV XDG_CONFIG_HOME=/config
ENV UMASK=0002

USER root

WORKDIR /app

# hadolint ignore=DL3018
RUN \
    apk update \
    apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        coreutils \
        curl \
        icu-data-full \
        icu-libs \
        jq \
        libintl \
        nano \
        tzdata \
        util-linux \
        grep \
        procps \
        git \
    && update-ca-certificates


COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
