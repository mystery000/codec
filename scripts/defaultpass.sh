#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][DEFAULTPASS]: No codec user defined!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[CODEX_CLI][DEFAULTPASS]: No password hash defined!"
    exit 1
fi

echo "[CODEX_CLI][DEFAULTPASS]: Short hash..."
HASH="$2"
HASH="$(echo -n "$HASH" | sha256sum | cut -d' ' -f1)"
HASH=${HASH:0:64}

echo "[CODEX_CLI][DEFAULTPASS]: Default password hash..."
docker rm -f codexcli-hash-helper > /dev/null 2>&1
docker run -it --rm \
    --name "codexcli-hash-helper" \
    -v "$CODEC_USER_DATA/.codec:/app" \
    ubuntu:22.04 \
        bash -c \
        "mkdir -p /app/hash \
        && echo -n '$HASH' > /app/hash/$1.hash"

echo "[CODEX_CLI][DEFAULTPASS]: Default password hash set!"
