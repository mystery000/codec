#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "[CODEX_CLI][ATTACH]: No codec user defined!"
    exit 1
fi

echo "[CODEX_CLI][ATTACH]: Attach to '$1':"
docker exec -it "codec_$1" bash