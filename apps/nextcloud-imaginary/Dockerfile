# https://github.com/nextcloud/all-in-one/tree/main/Containers/imaginary
FROM ghcr.io/trueforge-org/go-alpine:1.25.1 as go

ARG IMAGINARY_COMMMIT=b632dae8cc321452c3f85bcae79c580b1ae1ed84

# hadolint ignore=DL3018
RUN set -ex; \
    apk add --no-cache \
        vips-jxl \
        vips-dev \
        vips-heif \
        build-base \
        vips-magick \
        vips-poppler; \
    go install github.com/h2non/imaginary@${IMAGINARY_COMMMIT}

FROM ghcr.io/trueforge-org/alpine:3.22.1

USER root

# hadolint ignore=DL3018
RUN set -ex; \
    apk add --no-cache \
        vips \
        vips-jxl \
        vips-heif \
        vips-magick \
        vips-poppler \
        ca-certificates

COPY --from=go /go/bin/imaginary /usr/local/bin/imaginary

USER nobody

# https://github.com/h2non/imaginary#memory-issues
ENV MALLOC_ARENA_MAX=2

CMD ["imaginary", "-p", "${PORT:-9000}"]
