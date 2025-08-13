
# Stage 1: Base image with Debian and required packages
FROM debian:bullseye AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    iproute2 \
    iptables \
    wireguard-tools \
    caddy \
    tailscale \
    && rm -rf /var/lib/apt/lists/*

# Stage 2: Final image
FROM debian:bullseye

# Copy Caddy and Tailscale binaries from builder
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY --from=builder /usr/sbin/tailscaled /usr/sbin/tailscaled
COPY --from=builder /usr/bin/tailscale /usr/bin/tailscale

# Copy Caddyfile and start.sh
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh

# Make start.sh executable
RUN chmod +x /start.sh

# Expose port 8080
EXPOSE 8080

# Set entrypoint
CMD ["/start.sh"]
