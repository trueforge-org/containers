
# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04

# NGINX version explicitly set
ARG VERSION

USER root

# Install NGINX and required tools
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y \
        nginx=$VERSION; \
    rm -rf /var/lib/apt/lists/*

# Copy configuration files into container
COPY --chmod=777 ./nginx.conf  /etc/nginx/nginx.conf
COPY --chmod=777 ./config/default.conf /config/default.conf

# Ensure NGINX directories are writable
RUN set -eux; \
    mkdir -p /tmp/nginx-temp /var/cache/nginx ; \
    chmod -R 777 /config /etc/nginx; \
    ln -sf /dev/stdout /var/log/nginx/access.log; \
    ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 8080
STOPSIGNAL SIGQUIT

USER nobody:nogroup

CMD ["nginx", "-g", "daemon off;"]
