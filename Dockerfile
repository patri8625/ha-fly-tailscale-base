FROM caddy:latest

# Install dependencies
RUN apt-get update && apt-get install -y     curl     gnupg     lsb-release     iproute2     iptables     wireguard-tools     && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.gpg | gpg --dearmor -o /usr/share/keyrings/tailscale-archive-keyring.gpg &&     curl -fsSL https://pkgs.tailscale.com/stable/debian/bullseye.list | tee /etc/apt/sources.list.d/tailscale.list &&     apt-get update && apt-get install -y tailscale &&     rm -rf /var/lib/apt/lists/*

# Copy Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8080

CMD ["/start.sh"]
