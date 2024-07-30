#!/usr/bin/env bash

echo "[CODEX][CHANGELOGS]: Init..."
touch /codex/.codex/changelogs.md

if [ -f "/codex/.codex/changelogs.md" ]; then
  if [ "$(cat /etc/codex/changelogs.md)" == "$(cat /codex/.codex/changelogs.md)" ]; then
    echo "[CODEX][CHANGELOGS]: No changes."
    exit 0
  fi
fi

rm -rf /codex/.codex/changelogs.md
cp /etc/codex/changelogs.md /codex/.codex/changelogs.md
cp /etc/codex/changelogs.md /codex/workspace/CODEX_CHANGELOGS.md