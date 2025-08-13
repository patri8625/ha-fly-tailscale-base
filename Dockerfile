
# Use Debian as the base image
FROM debian:bullseye-slim

# Install dependencies and Caddy
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    iproute2 \
    iptables \
    wireguard-tools \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg \
    && curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.list | tee /etc/apt/sources.list.d/tailscale.list \
    && apt-get update \
    && apt-get install -y tailscale \
    && rm -rf /var/lib/apt/lists/*

# Install Caddy
RUN curl -fsSL https://caddyserver.com/api/download?os=linux&arch=amd64 | tar -xz -C /usr/bin caddy \
    && chmod +x /usr/bin/caddy

# Copy configuration and startup script
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 8080
EXPOSE 8080

# Start script
CMD ["/start.sh"]
