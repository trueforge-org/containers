# hadolint ignore=DL3007
FROM ghcr.io/trueforge-org/alpine:3.22.1

ARG TARGETPLATFORM
ARG VERSION

USER root

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2086,SC2155
RUN \
  apk update && \
  apk --no-cache add \
    mariadb-client \
  && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='linux-x64' ;; \
  esac \
  && apk del \
    jq \
  && \
  rm -rf \
    /tmp/* \
    /var/cache/apk/* \
  && chmod -R u=rwX,go=rX /app \
  && printf "umask %d" "${UMASK}" >> /etc/profile \
  && update-ca-certificates

USER nobody:nogroup








