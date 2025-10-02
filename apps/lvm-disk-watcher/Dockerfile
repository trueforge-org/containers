FROM ghcr.io/trueforge-org/ubuntu:24.04

ARG TARGETPLATFORM
ARG VERSION

USER root

# Copy files with ownership
COPY --chown=nobody:nogroup . /

# Install LVM and dependencies, make script executable
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        lvm2 \
        device-mapper && \
    chmod +x /app/watch_lvm.sh && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

ENTRYPOINT ["/bin/bash", "/scripts/watch_lvm.sh"]

USER nobody:nogroup
