# syntax=docker/dockerfile:1

ARG VERSION
ARG ALPINE_VERSION
ARG ALPINE_VERSION_STRIPPED

# Stage 1: Upstream Python Alpine image with optimized binaries
FROM python:${VERSION}-alpine${ALPINE_VERSION_STRIPPED} AS python-build

# Stage 2: Your custom Alpine base
FROM ghcr.io/trueforge-org/alpine:${ALPINE_VERSION}

# Set Python and runtime environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_BREAK_SYSTEM_PACKAGES=1 \
    PIP_ROOT_USER_ACTION=ignore \
    PATH=/usr/local/bin:$PATH \
    LANG=C.UTF-8

USER root

# Install the Alpine Python package with the same version as upstream
RUN apk add --no-cache python3=${VERSION} py3-pip \
    ca-certificates tzdata \
    libffi libnsl libtirpc bzip2 zlib xz sqlite-libs tk

# Replace binaries with upstream optimized Python
COPY --from=python-build /usr/local/bin /usr/local/bin
COPY --from=python-build /usr/local/lib /usr/local/lib

# Optional: recreate standard symlinks
RUN set -eux; \
    for src in idle3 pip3 pydoc3 python3 python3-config; do \
        dst="$(echo "$src" | tr -d 3)"; \
        [ -s "/usr/local/bin/$src" ]; \
        [ ! -e "/usr/local/bin/$dst" ]; \
        ln -svT "$src" "/usr/local/bin/$dst"; \
    done

USER nobody:nogroup

# Verify and delete unneeded parts of python
RUN set -eux; \
    # Basic Python runtime checks
    python3 --version; \
    pip3 --version; \
    python3 -c "import sys, os, ssl, sqlite3, tk, zlib, bz2; print('Python runtime OK')"; \
    \
    # Optional: run Python self-tests (slower)
    cd /usr/local/lib/python${VERSION}; \
    python3 -m test -w -v; \
    \
    # Remove tests and headers to reduce image size
    rm -rf /usr/local/lib/python${VERSION}/test /usr/local/include

CMD ["python3"]
