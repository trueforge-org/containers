# syntax=docker/dockerfile:1

FROM ghcr.io/trueforge-org/ubuntu:24.04

USER root

ENV RUNNER_MANUALLY_TRAP_SIG=1 \
    ACTIONS_RUNNER_PRINT_LOG_TO_STDOUT=1 \
    ImageOS=ubuntu22 \
    HOMEBREW_NO_ANALYTICS=1 \
    HOMEBREW_NO_ENV_HINTS=1 \
    HOMEBREW_NO_INSTALL_CLEANUP=1

# ---------------------------
# Step 1: Create runner user early
# ---------------------------
RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

WORKDIR /home/runner

ARG TARGETOS=linux
ARG VERSION
ARG RUNNER_CONTAINER_HOOKS_VERSION
ARG DOCKER_VERSION
ARG BUILDX_VERSION

# Architecture mappings
ARG TARGETARCH
ARG RUNNER_ARCH=${TARGETARCH/arm64/arm64}
ARG RUNNER_ARCH=${TARGETARCH/amd64/x64}
ARG DOCKER_ARCH=${TARGETARCH/arm64/aarch64}
ARG DOCKER_ARCH=${TARGETARCH/amd64/x86_64}

# ---------------------------
# Step 2: Install dependencies and add keyrings/repositories
# ---------------------------
RUN set -eux; \
    mkdir -p -m 755 /etc/apt/keyrings; \
    out=$(mktemp); \
    wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg; \
    cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null; \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | tee /etc/apt/sources.list.d/github-cli.list > /dev/null; \
    \
    add-apt-repository -y ppa:git-core/ppa; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        git \
        gh \
        unzip \
        jo \
        moreutils \
        sudo \
        zstd; \
    \
    case "${TARGETARCH}" in \
        'amd64') apt-get install -y --no-install-recommends gcc ;; \
    esac; \
    \
    curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_${TARGETARCH}" -o /usr/local/bin/yq; \
    chmod +x /usr/local/bin/yq; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ---------------------------
# Step 3: Download and extract GitHub Actions runner
# ---------------------------
RUN curl -fsSL -o runner.tar.gz "https://github.com/actions/runner/releases/download/v${VERSION}/actions-runner-${TARGETOS}-${RUNNER_ARCH}-${VERSION}.tar.gz" \
    && tar xzf runner.tar.gz && rm runner.tar.gz \
    && chown -R runner:docker /home/runner

# ---------------------------
# Step 4: Download and extract container hooks
# ---------------------------
RUN curl -fsSL -o runner-container-hooks.zip "https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip" \
    && unzip runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip \
    && chown -R runner:docker /home/runner/k8s

# ---------------------------
# Step 5: Install Docker and Buildx
# ---------------------------
RUN curl -fsSL -o docker.tgz "https://download.docker.com/${TARGETOS}/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz" \
    && tar -xzf docker.tgz && rm docker.tgz \
    && install -o root -g root -m 755 docker/* /usr/bin/ && rm -rf docker \
    && mkdir -p /usr/local/lib/docker/cli-plugins \
    && curl -fsSL -o /usr/local/lib/docker/cli-plugins/docker-buildx \
        "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.linux-${TARGETARCH}" \
    && chmod +x /usr/local/lib/docker/cli-plugins/docker-buildx

# ---------------------------
# Step 6: Optional Homebrew installation
# ---------------------------
USER runner
RUN if [ "${TARGETARCH}" = "amd64" ]; then \
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"; \
    fi
