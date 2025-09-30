FROM ghcr.io/trueforge-org/alpine:3.22.1

ARG VERSION

ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64/arm64}
ARG TARGETARCH=${TARGETARCH/amd64/amd64}

# hadolint ignore=DL3002
USER root

# hadolint ignore=DL3018,DL4006
RUN apk update && apk add --no-cache git \
    && curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/${TARGETARCH}/kubectl" \
    && curl -LO "https://dl.k8s.io/release/${VERSION}/bin/linux/${TARGETARCH}/kubectl.sha256" \
    && echo "$(cat kubectl.sha256)  kubectl" | sha256sum -c \
    && install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
    && kubectl version --client --output=yaml \
    && curl -fsSL -o cmctl.tar.gz https://github.com/cert-manager/cert-manager/releases/download/v1.11.0/cmctl-linux-${TARGETARCH}.tar.gz \
    && tar xzf cmctl.tar.gz \
    && mv cmctl /usr/local/bin \
    && apk del curl


USER nobody:nogroup
