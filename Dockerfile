FROM debian:bullseye-slim

# Install dependencies
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

# Add Tailscale GPG key manually to avoid NO_PUBKEY error
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg

# Add Tailscale repository
RUN echo "deb [signed-by=/usr/share/keyrings/tailscale-archive-keyring.gpg] https://pkgs.tailscale.com/stable/debian bullseye main" > /etc/apt/sources.list.d/tailscale.list

# Install Tailscale
RUN apt-get update && apt-get install -y tailscale && rm -rf /var/lib/apt/lists/*

# Install Caddy via APT
RUN curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
  && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
  && apt-get update \
  && apt-get install -y caddy

# Copy configuration files
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh

# Make start.sh executable
RUN chmod +x /start.sh

# Expose port 8080
EXPOSE 8080

# Start the container
CMD ["/start.sh"]
