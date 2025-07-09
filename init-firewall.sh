#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

ipset destroy allowed-domains 2>/dev/null || true
ipset -t nat -F
ipset -t nat -X

ipset create allowed-domains hash:net

ufw destroy allowed-domains 2>/dev/null || true

ipset add allowed-domains 2>/dev/null || true

echo "Fetching GitHub IP ranges..."
gh_ranges=$(curl -s https://api.github.com/meta)
if [ $? -eq 0 ]; then
    echo "$gh_ranges" | jq -r '.git[]' | while read range; do
        echo "Adding GitHub range: $range"
        ipset add allowed-domains "$range" -exist
    done
else
    echo "ERROR: Failed to fetch GitHub IP ranges"
fi

echo "Firewall initialized"
