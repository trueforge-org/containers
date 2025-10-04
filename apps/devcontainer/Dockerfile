FROM ghcr.io/trueforge-org/golang:1.25.1 AS go

# hadolint ignore=DL3007
FROM ghcr.io/trueforge-org/python:3.13.7

ARG VERSION

# Copy Go from the first stage
COPY --from=go /usr/local/go /usr/local/go

ENV GOTOOLCHAIN=local
ENV GOPATH=/go
# Ensure Go is in PATH
ENV PATH="/usr/local/go/bin:${PATH}"

LABEL dev.containers.features="common"

USER root

# hadolint ignore=DL3008,DL3015,SC2086,SC2155
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        age bind9-dnsutils direnv fish fzf \
        gettext git gh iputils-ping \
        moreutils openssh-client openssl yq \
        sshfs fuse3 sq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install additional tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sops \
        cilium-cli kubeconform stern && \
    rm -rf /var/lib/apt/lists/*; \
    # GitHub release binaries
    echo "=== Installing kubectl ==="; \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"; \
    chmod +x kubectl && mv kubectl /usr/local/bin/; \
    \
    echo "=== Installing helm ==="; \
    curl -fsSL "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3" | bash; \
    \
    echo "=== Installing k9s ==="; \
    curl -LO "https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz"; \
    tar -xzf k9s_Linux_amd64.tar.gz -C /usr/local/bin k9s; rm k9s_Linux_amd64.tar.gz; \
    \
    echo "=== Installing kustomize ==="; \
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash; \
    mv kustomize /usr/local/bin/; \
    \
    echo "=== Installing starship ==="; \
    curl -LO "https://github.com/starship/starship/releases/latest/download/starship-x86_64-unknown-linux-gnu.tar.gz"; \
    tar -xzf starship-x86_64-unknown-linux-gnu.tar.gz -C /usr/local/bin starship && \
    rm starship-x86_64-unknown-linux-gnu.tar.gz && \
    chmod +x /usr/local/bin/starship

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
