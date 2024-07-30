#!/usr/bin/env bash

echo "[CODEX][HEALTH]: Create folder..."

mkdir -p /codex/.codex/mods
mkdir -p /codex/.codex/enabled-mods

# codex module migration
if [ -d "/codex/.codex/optional" ]
then
    cp /codex/.codex/optional/* /codex/.codex/mods
fi
rm -rf /codex/.codex/modules
rm -rf /codex/.codex/optional

mkdir -p /codex/mounts
mkdir -p /codex/archive
mkdir -p /codex/ws

echo "[CODEX][HEALTH]: Copy codex skel..."
cp -nr /etc/codex/skel/* /codex/.codex/

echo "[CODEX][HEALTH]: Mounting..."
/etc/codex/mounts.js

echo "[CODEX][HEALTH]: Linking 'config.yaml'..."
mkdir -p /root/.config/code-server
rm -rf /root/.config/code-server/config.yaml
cp -n /etc/codex/vscode-server.yaml /codex/.codex/vscode-server.yaml
ln -s /codex/.codex/vscode-server.yaml /root/.config/code-server/config.yaml 
echo "Linked: '/root/.config/code-server/config.yaml'"

echo "[CODEX][HEALTH]: Linking 'keybindings.json'..."
mkdir -p /root/.local/share/code-server/User
rm -rf /codex/mounts/vscode/User/keybindings.json
ln -s /codex/.codex/keybindings.json /root/.local/share/code-server/User/keybindings.json
echo "Linked: '/root/.local/share/code-server/User/keybindings.json'"

echo "[CODEX][HEALTH]: Linking 'vscode/User/settings.json'..."
mkdir -p /root/.local/share/code-server/User
rm -rf /codex/mounts/vscode/User/settings.json
ln -s /codex/.codex/settings.json /root/.local/share/code-server/User/settings.json
echo "Linked: '/root/.local/share/code-server/User/settings.json'"

# echo "[CODEX][HEALTH]: Linking 'product.json'..."
# mkdir -p /usr/lib/code-server/lib/vscode
# cp -n /usr/lib/code-server/lib/vscode/product.json /codex/.codex/product.json
# rm -rf /usr/lib/code-server/lib/vscode/product.json
# ln -s /codex/.codex/product.json /usr/lib/code-server/lib/vscode/product.json
# echo "Linked: '/usr/lib/code-server/lib/vscode/product.json'"

echo "[CODEX][HEALTH]: Linking..."
rm -rf /usr/lib/code-server/src/browser/pages
ln -s /etc/codex/login /usr/lib/code-server/src/browser/pages
echo "Linked: '/usr/lib/code-server/src/browser'"

/etc/codex/readme.sh
/etc/codex/changelogs.sh

echo "[CODEX][HEALTH]: Linking home 'ws' dir..."
rm -rf /root/ws
ln -s /codex/ws /root/ws
echo "Link in `/codex/ws` to '/root/ws' created!"

echo "[CODEX][HEALTH]: Linking home 'workspace' dir..."
rm -rf /root/workspace
ln -s /codex/ws /root/workspace
echo "Link in `/root/workspace` to '/codex/ws' created!"

echo "[CODEX][HEALTH]: Linking home 'codex' dir..."
rm -rf /root/codex
ln -s /codex /root/codex
echo "Link in `/root/codex` to '/codex' created!"

echo "[CODEX][HEALTH]: Disable vscode telemetry..."
/etc/codex/vscode_telemetry.js
echo "[CODEX][HEALTH]: Telemetry disabled!"
