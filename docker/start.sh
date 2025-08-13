#!/bin/bash

# Start Tailscale
tailscaled &
sleep 5
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${TAILSCALE_HOSTNAME}

# Start Caddy
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
