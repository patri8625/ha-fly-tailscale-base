#!/bin/bash

echo "=== Test: alleen Caddy starten ==="
caddy version
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
