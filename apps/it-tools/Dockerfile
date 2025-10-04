# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/node:22.20 AS builder
ARG VERSION
WORKDIR /tmp
ENV HOME=/tmp
USER root
ADD https://github.com/CorentinTh/it-tools.git#${VERSION} .
RUN npm install -g corepack@latest \
    && corepack enable  \
    && corepack prepare pnpm@latest --activate \
    && pnpm install --prefer-offline \
    && pnpm build

FROM ghcr.io/trueforge-org/nginx:1.24.0
USER root
COPY --from=builder --chown=nobody:nogroup /tmp/dist/ /usr/share/nginx/html
USER nobody:nogroup
WORKDIR /usr/share/nginx/html
