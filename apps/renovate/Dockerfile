# hadolint ignore=DL3007
ARG VERSION
FROM docker.io/renovate/renovate:${VERSION}-full@sha256:fcbe8ca8c73d6f2d82552edae5248778ac5acbaaf21fff039492f53a1748ab2d


ARG CLUSTERTOOL_VERSION=2.0.6

# Download and set up the clustertool binary
RUN curl -L "https://github.com/trueforge-org/truecharts/releases/download/v${VERSION}/clustertool_${CLUSTERTOOL_VERSION}_linux_amd64.tar.gz" -o /tmp/clustertool.tar.gz \
    && tar -xzvf /tmp/clustertool.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/clustertool \
    && rm /tmp/clustertool.tar.gz

