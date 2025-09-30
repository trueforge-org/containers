# syntax=docker/dockerfile:1

ARG VERSION
ARG ALPINE_VERSION
ARG ALPINE_VERSION_STRIPPED
FROM python:${VERSION}-alpine${ALPINE_VERSION_STRIPPED} AS python-build

ARG ALPINE_VERSION
FROM ghcr.io/trueforge-org/alpine:${ALPINE_VERSION}

ARG VERSION

# Set Python and runtime environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PATH=/usr/local/bin:$PATH \
    CRYPTOGRAPHY_DONT_BUILD_RUST=1 \
    PIP_PREFER_BINARY=1 \
    UV_NO_CACHE=true \
    UV_SYSTEM_PYTHON=true \
    UV_EXTRA_INDEX_URL="https://wheel-index.linuxserver.io/alpine-3.22/ https://pypi.org/simple https://wheels.home-assistant.io/musllinux-index/" \
    UV_INDEX_STRATEGY="unsafe-best-match" \
    LANG=C.UTF-8

USER root

# Install the Alpine Python package with the same version as upstream
RUN VERSION_MINOR=$(echo $VERSION | cut -d. -f1-2) \
    && \
    apk add --no-cache python3~${VERSION_MINOR} py3-pip \
    libffi libnsl libtirpc bzip2 zlib xz sqlite-libs tk

# Replace binaries with upstream optimized Python
COPY --from=python-build /usr/local/bin /usr/local/bin
COPY --from=python-build /usr/local/lib /usr/local/lib

USER nobody:nogroup

# Verify and delete unneeded parts of python
RUN set -eux; \
    # Basic Python runtime checks
    python3 --version; \
    pip3 --version; \
    \
    # TODO: run Python self-tests
    # python3 -m test -w -v; \
    # \
    # Remove tests and headers to reduce image size
    rm -rf /usr/local/lib/python[0-9].[0-9]*/test /usr/local/include

CMD ["python3"]
