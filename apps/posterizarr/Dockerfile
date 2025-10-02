FROM ghcr.io/trueforge-org/python:3.13.7

ARG TARGETARCH
ARG VENDOR
ARG VERSION

ENV DEBCONF_NONINTERACTIVE_SEEN="true" \
    POWERSHELL_DISTRIBUTION_CHANNEL="PSDocker"

USER root
WORKDIR /app

# Install dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        imagemagick \
        libheif-dev \
        libjpeg-turbo8-dev \
        powershell \
        tar \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*; \
    \
    # Install PowerShell module
    pwsh -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; Install-Module -Name FanartTvAPI -Scope AllUsers -Force"; \
    chmod -R 755 /usr/local/share/powershell; \
    \
    # Install Python dependencies
    pip install --no-cache-dir apprise; \
    \
    # Download and extract Posterizarr
    curl -fsSL "https://github.com/fscorrupt/Posterizarr/archive/refs/tags/${VERSION}.tar.gz" \
        | tar xzf - -C /app --strip-components=1; \
    rm -rf /app/images; \
    find /app -type f \( -name "*.md" -o -name "*.zip" -o -name "*.yml" -o -name ".*" \) -delete; \
    \
    # Ensure proper permissions
    mkdir -p /app && chmod 755 /app

COPY . /

USER nobody:nogroup
WORKDIR /app
VOLUME ["/app"]
