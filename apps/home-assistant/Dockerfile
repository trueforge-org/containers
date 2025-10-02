# syntax=docker/dockerfile:1

ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
FROM ghcr.io/trueforge-org/python:3.13.7
ARG TARGETARCH
ARG ARCH=${TARGETARCH/arm64/aarch64}
ARG VERSION

ENV HOME="/config" \
    PYTHONUSERBASE="/usr/local" \
    VENV_FOLDER="/config/.venv"

USER root
WORKDIR /app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install runtime and build dependencies
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        binutils \
        bluez \
        bluez-cups \
        cups \
        udev \
        ffmpeg \
        git \
        hwdata \
        libimlib2 \
        iperf3 \
        iputils-ping \
        libcap2 \
        libftdi1 \
        libgpiod2 \
        libturbojpeg0-dev \
        libpulse0 \
        libstdc++6 \
        libxslt1.1 \
        libzbar0 \
        mailcap \
        libmariadb3 \
        net-tools \
        nmap \
        openssh-client \
        openssl \
        pianobar \
        libpq5 \
        pulseaudio \
        socat \
        libtiff6 \
        unzip \
        xz-utils \
        build-essential \
        default-libmysqlclient-dev \
        pkg-config \
        && rm -rf /var/lib/apt/lists/*; \
    apt-get update; \
    apt-get install -y --no-install-recommends --no-install-suggests \
        autoconf \
        build-essential \
        libffi-dev \
        && rm -rf /var/lib/apt/lists/*

# Install Python packages and Home Assistant
RUN pip install uv psycopg2-binary; \
    pip install mysqlclient --only-binary=:all: \
    curl -fsSL "https://github.com/home-assistant/core/archive/${VERSION}.tar.gz" \
        | tar xzf - -C /tmp --strip-components=1; \
    HOME_ASSISTANT_BASE=$(curl -fsSL "https://raw.githubusercontent.com/home-assistant/core/${VERSION}/build.yaml" \
        | grep "${ARCH}: " | cut -d ":" -f3); \
    uv pip install --index-strategy unsafe-best-match \
        --requirement "https://raw.githubusercontent.com/home-assistant/docker/${HOME_ASSISTANT_BASE}/requirements.txt"; \
    uv pip install --index-strategy unsafe-best-match --requirement /tmp/requirements_all.txt; \
    uv pip install --index-strategy unsafe-best-match homeassistant=="${VERSION}"; \
    curl -fsSL -o /bin/go2rtc "https://github.com/AlexxIT/go2rtc/releases/latest/download/go2rtc_linux_${TARGETARCH}"; \
    chmod +x /bin/go2rtc; \
    mkdir -p /config && chown nobody:nogroup -R /config; \
    rm -rf /root/.cache /tmp/*

# Copy local files
COPY . /

USER nobody:nogroup
WORKDIR /config
VOLUME ["/config"]

ENTRYPOINT ["/usr/bin/catatonit", "--", "/entrypoint.sh"]
