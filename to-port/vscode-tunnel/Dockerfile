FROM oci.trueforge.org/truecharts/ubuntu:latest@sha256:144d3bfe7088dfef5c6a62abadcb17cfb911bad92fc6eae0293ab5e633f2a1f7

ARG TARGETPLATFORM
ARG VERSION

# hadolint ignore=DL3002
USER root

# hadolint ignore=DL3018,DL4006
RUN apt-get update && \
    apt-get install -y git curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    curl -sL "https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64" \
        --output /tmp/vscode-cli.tar.gz && \
    tar -xf /tmp/vscode-cli.tar.gz -C /usr/bin && \
    rm /tmp/vscode-cli.tar.gz

USER nobody:nogroup

CMD [ "code", "tunnel", "--accept-server-license-terms" ]

ARG CONTAINER_NAME
ARG CONTAINER_VER



