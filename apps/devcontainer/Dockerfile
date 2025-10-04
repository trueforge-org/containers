# hadolint ignore=DL3007
FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG VERSION
ARG DEBIAN_FRONTEND=noninteractive

# hadolint ignore=DL3008,DL3015,SC2086,SC2155
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        age bash bind9-dnsutils ca-certificates curl direnv fish fzf \
        gettext git gh helm iputils-ping jq k9s kubectl kustomize \
        python3 python3-pip moreutils openssh-client openssl starship yq \
        sshfs fuse && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install additional tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        golang-go sops \
        cilium-cli kubeconform stern && \
    rm -rf /var/lib/apt/lists/*

# Install CLI tools via jpillora scripts
RUN for app in \
    "budimanjojo/talhelper!!?as=talhelper&type=script" \
    "fluxcd/flux2!!?as=flux&type=script" \
    "helmfile/helmfile!!?as=helmfile&type=script" \
    "kubecolor/kubecolor!!?as=kubecolor&type=script" \
    "kubernetes-sigs/krew!!?as=krew&type=script" \
    "siderolabs/talos!!?as=talosctl&type=script"; \
  do \
    echo "=== Installing ${app} ==="; \
    curl -fsSL "https://i.jpillora.com/${app}" | bash; \
  done

# Create Fish config directories
RUN mkdir -p /home/vscode/.config/fish/completions \
             /home/vscode/.config/fish/conf.d

# Add completions only if the command exists
RUN for tool in cilium flux helm helmfile k9s kubectl kustomize talhelper talosctl; do \
      if command -v "$tool" >/dev/null 2>&1; then \
        $tool completion fish > "/home/vscode/.config/fish/completions/${tool}.fish" || true; \
      fi; \
    done && \
    gh completion --shell fish > /home/vscode/.config/fish/completions/gh.fish || true && \
    stern --completion fish > /home/vscode/.config/fish/completions/stern.fish || true && \
    yq shell-completion fish > /home/vscode/.config/fish/completions/yq.fish || true

# Fish hooks
RUN printf '%s\n' \
    "if status is-interactive" \
    "    direnv hook fish | source" \
    "    starship init fish | source" \
    "end" \
    > /home/vscode/.config/fish/conf.d/hooks.fish

# Fish aliases
RUN printf '%s\n' \
    "alias kubectl kubecolor" \
    "alias k kubectl" \
    "alias task go-task" \
    > /home/vscode/.config/fish/conf.d/aliases.fish

# Custom fish prompt
RUN echo "set fish_greeting" > /home/vscode/.config/fish/conf.d/fish_greeting.fish

# Direnv whitelist
RUN mkdir -p /home/vscode/.config/direnv && \
    tee /home/vscode/.config/direnv/direnv.toml > /dev/null <<EOF
[whitelist]
prefix = [ "/workspaces" ]
EOF

# Fix permissions for devcontainer user
RUN chown -R vscode:vscode /home/vscode/ && chmod -R 755 /home/vscode/

ARG TARGETARCH
ARG TARGETARCH=${TARGETARCH/arm64/ARM64}
ARG TARGETARCH=${TARGETARCH/amd64/amd64}

# Download and set up the clustertool binary
RUN curl -L "https://github.com/trueforge-org/truecharts/releases/download/v${VERSION}/clustertool_${VERSION}_linux_${TARGETARCH}.tar.gz" -o /tmp/clustertool.tar.gz \
    && tar -xzvf /tmp/clustertool.tar.gz -C /usr/local/bin \
    && chmod +x /usr/local/bin/clustertool \
    && rm /tmp/clustertool.tar.gz
