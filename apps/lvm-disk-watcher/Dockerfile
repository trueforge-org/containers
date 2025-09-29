FROM ghcr.io/trueforge-org/alpine:3.22.1

ARG TARGETPLATFORM
ARG VERSION

# hadolint ignore=DL3002
USER root

COPY --chown=nobody:nogroup . /

# hadolint ignore=DL3018,DL4006
RUN apk update && apk add --no-cache lvm2 lvm2-dmeventd device-mapper-event-libs \
    && chmod +x /app/watch_lvm.sh

WORKDIR /app

ENTRYPOINT ["/bin/bash", "/scripts/watch_lvm.sh"]






