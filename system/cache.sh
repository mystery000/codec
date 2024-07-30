#!/usr/bin/env bash

echo "[CODEX][CACHE]: Clear vscode cache files..."
rm -rf /codex/mounts/vscode/User/caches
rm -rf /codex/mounts/vscode/logs
rm -rf /codex/mounts/vscode/CachedExtensions
rm -rf /codex/mounts/vscode/coder-logs
rm -rf /codex/mounts/vscode/User/customBuiltinExtensionsCache.json
rm -rf /tmp/*

