FROM docker.io/library/python:3.13-alpine3.22
ARG VERSION

ENV XDG_CONFIG_HOME=/config \
    UMASK=0002

ENV \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/"

WORKDIR /app

# Install required packages
# hadolint ignore=DL3018
RUN apk add --no-cache \
        bash \
        ca-certificates \
        catatonit \
        curl \
        icu-data-full \
        icu-libs \
        jq \
        libintl \
        nano \
        tzdata \
        grep \
    && update-ca-certificates \
    && rm -rf /var/cache/apk/*

# Copy base-scripts files with correct ownership
COPY --chown=nobody:nogroup . /

# Switch to non-root user
USER nobody:nogroup

WORKDIR /config
VOLUME ["/config"]

# Start the container with catatonit as init
ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]



