# hadolint ignore=DL3007
FROMghcr.io/trueforge-org/alpine:3.22.1@sha256:6dc807ae4f2867cb2d00d061f8f579f1966420ad792c179ac68072ab235109f8

ARG TARGETPLATFORM
ARG VERSION

USER root

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008,DL3015,SC2086,SC2155
RUN \
apk update && \
  apk --no-cache update && \
  apk --no-cache add \
    postgresql-client && \
  case "${TARGETPLATFORM}" in \
    'linux/amd64') export ARCH='linux-x64' ;; \
  esac && \
  apk del --no-cache jq && \
  rm -rf /var/cache/apk/* /tmp/* /var/tmp/* && \
  chmod -R u=rwX,go=rX /app && \
  printf "umask %d" "${UMASK}" >> /etc/profile

USER nobody:nogroup

COPY ./containers/apps/db-wait-postgres/entrypoint.sh /entrypoint.sh
CMD ["/entrypoint.sh"]







