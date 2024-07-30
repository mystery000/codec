#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][CLOSE]: No codec user defined!"
    exit 1
fi

echo "[CODEX_CLI][CLOSE]: Remove container for '$1'..."
docker rm -f "codec_$1" > /dev/null 2>&1
echo "[CODEX_CLI][CLOSE]: Container removed!"
