FROM public.ecr.aws/docker/library/alpine:3.22.1@sha256:4bcff63911fcb4448bd4fdacec207030997caf25e9bea4045fa6c8c44de311d1

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
# hadolint ignore=DL3018
RUN apk add --no-cache ca-certificates curl

# https://github.com/nextcloud/notify_push/releases
ENV NOTIFY_PUSH_VERSION 1.2.0

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN set -ex; \
    arch="x86_64"; \
    triplet="unknown-linux-musl"; \
    \
    wget -q -O /usr/local/bin/notify_push "https://github.com/nextcloud/notify_push/releases/download/v${NOTIFY_PUSH_VERSION}/notify_push-$arch-$triplet"; \
    \
    chmod +x /usr/local/bin/notify_push; \
    notify_push --version

USER nobody

COPY --chmod=775 . /
