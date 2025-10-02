# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04
ARG VERSION

USER root

# Install PostgreSQL client
RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client && \
    rm -rf /var/lib/apt/lists/* /tmp/*

# Copy application files
COPY . /

# Ensure non-root user exists
RUN groupadd -r nobody && useradd -r -g nobody nobody
USER nobody:nogroup
