#!/bin/bash

echo "=== Start Tailscale ==="
tailscaled &

sleep 5
tailscale up --authkey=${TAILSCALE_AUTHKEY} --hostname=${TAILSCALE_HOSTNAME}

echo "=== Genereer Caddyfile ==="
cat <<EOF > /etc/caddy/Caddyfile
:8080 {
  reverse_proxy ${TAILSCALE_HA_SCHEME}://${TAILSCALE_HA_HOST}:${TAILSCALE_HA_PORT}
}
EOF

echo "=== Start Caddy ==="
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
