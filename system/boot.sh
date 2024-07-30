#!/usr/bin/env bash

source /etc/environment

# clear cache files
/etc/codex/cache.sh

# health check
/etc/codex/health.sh

# install tools
/etc/codex/tools.sh

apt-get update

# default vscode extensions
/etc/codex/extensions.sh

# init mod system
/etc/codex/mods.sh

# reload sysctl
sysctl -p

# run vscode server service
echo "[CODEX][VSCODE]: Start vscode service..."
systemctl start vscode

# init async mods
/etc/codex/mods_async.sh

echo "[CODEX][VSCODE]: Done!"
