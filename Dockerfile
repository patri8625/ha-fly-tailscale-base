FROM caddy:latest

# Install Tailscale
RUN apt-get update && apt-get install -y curl gnupg2 && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && apt-get install -y tailscale

# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Start Tailscale and Caddy
CMD tailscaled & \
    tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=fly-caddy-proxy --accept-routes && \
    caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
