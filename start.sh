#!/bin/bash

echo "=== Start.sh gestart ==="

# Start Tailscale
echo "→ Start tailscaled..."
tailscaled &
sleep 5

echo "→ Tailscale verbinden..."
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --hostname="${TAILSCALE_HOSTNAME}"
if [ $? -ne 0 ]; then
  echo "❌ Tailscale kon niet verbinden."
  exit 1
fi

# Test verbinding met Home Assistant
echo "→ Test verbinding met Home Assistant..."
curl -s --connect-timeout 5 http://100.89.204.56:8123 > /dev/null
if [ $? -ne 0 ]; then
  echo "⚠️ Home Assistant lijkt niet bereikbaar via Tailscale."
else
  echo "✅ Home Assistant is bereikbaar via Tailscale."
fi

# Start Caddy in de voorgrond
echo "→ Start Caddy..."
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
