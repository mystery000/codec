#!/usr/bin/env bash

set -e  # Exit immediately if a command exits with a non-zero status.

echo "[CODEX][TOOLS]: Downloading DevopsX..."

REPO="https://github.com/mystery000/devopsx.git"
DIR="/devopsx"
LINK_PATH="/usr/local/bin/devopsx"
BIN_PATH="$DIR/.venv/bin/devopsx"

if [ -d "$DIR" ]; then
    cd "$DIR"
    git pull
else
    git clone "https://github.com/mystery000/devopsx.git" "$DIR"
    cd "$DIR"
    chmod +x setup.sh
fi

sudo apt-get update
/devopsx/setup.sh

if [ -L "$LINK_PATH" ]; then
    rm "$LINK_PATH"
elif [ -f "$LINK_PATH" ]; then
    echo "Warning: $LINK_PATH exists and is not a symbolic link. Manual intervention may be required."
    exit 1
fi

ln -s "$BIN_PATH" "$LINK_PATH"
echo "Installed: DevopsX"
