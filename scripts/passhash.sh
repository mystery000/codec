#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][PASSHASH]: No codex user defined!"
    exit 1
fi

if [ -z "$2" ]; then
    echo "[CODEX_CLI][PASSHASH]: No password hash defined!"
    exit 1
fi

echo "[CODEX_CLI][PASSHASH]: Short hash..."
HASH="$2"
HASH=${HASH:0:64}

echo "[CODEX_CLI][PASSHASH]: Save startup arguments..."
docker rm -f codexcli-hash-helper > /dev/null 2>&1
docker run -it --rm \
    --name "codexcli-hash-helper" \
    -v "$CODEX_USER_DATA/.codex:/app" \
    ubuntu:22.04 \
        bash -c \
        "mkdir -p /app/ports \
        && echo -n '$HASH' > /app/ports/$1.hash"

echo "[CODEX_CLI][PASSHASH]: Set password hash..."
docker exec -it "codex_$1" codex -rh "$HASH"

echo "[CODEX_CLI][PASSHASH]: Password hash set!"
