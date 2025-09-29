# hadolint ignore=DL3007
ARG VERSION

FROM docker.io/renovate/renovate:${VERSION}-full


ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64}
ARG TARGETARCH=${TARGETARCH/amd64}
ARG CLUSTERTOOL_VERSION=2.0.6

# Download and set up the clustertool binary
RUN curl -L "https://github.com/trueforge-org/truecharts/releases/download/v${CLUSTERTOOL_VERSION}/clustertool_${CLUSTERTOOL_VERSION}_linux_${TARGETARCH}.tar.gz" -o /tmp/clustertool.tar.gz \
    && tar -xzvf /tmp/clustertool.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/clustertool \
    && rm /tmp/clustertool.tar.gz

