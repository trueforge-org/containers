FROM oci.trueforge.org/truecharts/alpine:v3.18.4@sha256:cc37d84517c2d4420c67b618d87b6c88a367ec3afd6f5176ce4f7ae1fe4eeaf8

ARG TARGETPLATFORM
ARG VERSION

# hadolint ignore=DL3002
USER root

# hadolint ignore=DL3018,DL4006
RUN apk update && apk add --no-cache curl


USER nobody:nogroup

ARG CONTAINER_NAME
ARG CONTAINER_VER



