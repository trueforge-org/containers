FROM ghcr.io/trueforge-org/alpine:3.22.1

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl

ARG VERSION

ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64/aarch64}
ARG TARGETARCH=${TARGETARCH/amd64/x86_64}

ARG TRIPLET="unknown-linux-musl"

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN set -ex; \
    wget -q -O /usr/local/bin/notify_push "https://github.com/nextcloud/notify_push/releases/download/v${VERSION}/notify_push-${TARGETARCH}-${TRIPLET}"; \
    \
    chmod +x /usr/local/bin/notify_push; \
    notify_push --version

USER nobody

COPY --chmod=775 . /
