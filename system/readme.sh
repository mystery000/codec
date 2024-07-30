#!/usr/bin/env bash

echo "[CODEX][README]: Init..."
touch /codex/.codex/readme.md

if [ -f "/codex/.codex/readme.md" ]; then
  if [ "$(cat /etc/codex/readme.md)" == "$(cat /codex/.codex/readme.md)" ]; then
    echo "[CODEX][README]: No changes."
    exit 0
  fi
fi

rm -rf /codex/.codex/readme.md
cp /etc/codex/readme.md /codex/.codex/readme.md
cp /etc/codex/readme.md /codex/workspace/CODEX_README.md