#!/usr/bin/env bash

echo "[CODEX][README]: Init..."
touch /codec/.codec/readme.md

if [ -f "/codec/.codec/readme.md" ]; then
  if [ "$(cat /etc/codec/readme.md)" == "$(cat /codec/.codec/readme.md)" ]; then
    echo "[CODEX][README]: No changes."
    exit 0
  fi
fi

rm -rf /codec/.codec/readme.md
cp /etc/codec/readme.md /codec/.codec/readme.md
cp /etc/codec/readme.md /codec/workspace/CODEC_README.md