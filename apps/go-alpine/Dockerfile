# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/alpine:3.22.1 AS build

ENV PATH /usr/local/go/bin:$PATH

ARG VERSION
ARG TARGETARCH

USER root

RUN set -eux; \
    apk add --no-cache gnupg; \
    \
    url="https://dl.google.com/go/go${VERSION}.linux-${TARGETARCH}.tar.gz"; \
    wget -O go.tgz "$url"; \
    wget -O go.tgz.asc "$url.asc"; \
    \
    GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys B9AE9905; \
    gpg --batch --verify go.tgz.asc go.tgz; \
    rm -rf "$GNUPGHOME" go.tgz.asc; \
    \
    tar -C /usr/local -xzf go.tgz; \
    rm go.tgz; \
    \
    mkdir -p /target/usr/local; \
    mv /usr/local/go /target/usr/local/go; \
    ln -svfT /target/usr/local/go /usr/local/go; \
    \
    go version; \
    apk del gnupg

FROM ghcr.io/trueforge-org/alpine:3.22.1

USER root

ARG VERSION
ENV GOTOOLCHAIN=local
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

COPY --from=build --link /target/ /

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH
