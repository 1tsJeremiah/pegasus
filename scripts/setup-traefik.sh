#!/bin/bash

set -e

VERSION="3.3.5"
DOWNLOAD_URL="https://github.com/traefik/traefik/releases/download/v${VERSION}/traefik_v${VERSION}_linux_amd64.tar.gz"
BIN_PATH="/usr/local/bin/traefik"
TAR_FILE="traefik_v${VERSION}_linux_amd64.tar.gz"

echo "📦 Installing Traefik v$VERSION"

# Download if needed
if [ ! -f "$TAR_FILE" ]; then
  curl -LO "$DOWNLOAD_URL"
fi

# Remove existing binary if present
sudo rm -f "$BIN_PATH"

# Extract binary to /usr/local/bin
sudo tar --overwrite -xvzf "$TAR_FILE" -C /usr/local/bin traefik

# Ensure it's executable
sudo chmod +x "$BIN_PATH"

# Optional cleanup
rm -f "$TAR_FILE"

# Verify
echo "✅ Traefik installed at $BIN_PATH"
"$BIN_PATH" version
