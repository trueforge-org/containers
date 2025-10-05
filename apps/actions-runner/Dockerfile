# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04

ARG TARGETOS=linux
ARG VERSION
ARG RUNNER_CONTAINER_HOOKS_VERSION
ARG DOCKER_VERSION
ARG BUILDX_VERSION

ARG TARGETARCH
ARG DOCKER_ARCH=${TARGETARCH/arm64/aarch64}
ARG DOCKER_ARCH=${TARGETARCH/amd64/x86_64}

ARG RUNNER_ARCH=${TARGETARCH/arm64/arm64}
ARG RUNNER_ARCH=${TARGETARCH/amd64/x64}

ENV RUNNER_MANUALLY_TRAP_SIG=1
ENV ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1
ENV ImageOS=ubuntu22

ENV HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    HOMEBREW_NO_INSTALL_CLEANUP=1

# Install base dependencies
RUN apt update -y \
    && apt install -y --no-install-recommends sudo lsb-release gpg-agent unzip curl \
    && rm -rf /var/lib/apt/lists/*

# Configure git-core/ppa based on guidance here:  https://git-scm.com/download/linux
RUN add-apt-repository ppa:git-core/ppa \
    && apt update -y \
    && apt install -y git \
    && rm -rf /var/lib/apt/lists/*

# Create runner user and docker group
RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

WORKDIR /home/runner

# Download and extract GitHub Actions runner
RUN export RUNNER_ARCH=${TARGETARCH} \
    && curl -f -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-${TARGETOS}-${RUNNER_ARCH}-${VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

# Download and extract runner container hooks
RUN curl -f -L -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip

# Install Docker and Buildx
RUN export RUNNER_ARCH=${TARGETARCH} \
    && curl -fLo docker.tgz https://download.docker.com/${TARGETOS}/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz \
    && tar zxvf docker.tgz \
    && rm -rf docker.tgz \
    && mkdir -p /usr/local/lib/docker/cli-plugins \
    && curl -fLo /usr/local/lib/docker/cli-plugins/docker-buildx \
        "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-${TARGETARCH}" \
    && chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx

RUN install -o root -g root -m 755 docker/* /usr/bin/ && rm -rf docker

# Install additional tools and GitHub CLI
RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends --no-install-suggests \
        ca-certificates \
        jo \
        moreutils \
        wget \
        zstd \
    && case "${TARGETARCH}" in \
        'amd64') apt-get -qq install -y --no-install-recommends --no-install-suggests gcc ;; \
    esac \
    && curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH}" -o /usr/local/bin/yq \
        && chmod +x /usr/local/bin/yq \
    && mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && apt update \
        && apt install gh -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER runner

RUN case "${TARGETARCH}" in \
        'amd64') /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" ;; \
    esac
