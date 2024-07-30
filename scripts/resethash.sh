#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][RESETHASH]: No codex user defined!"
    exit 1
fi

echo "[CODEX_CLI][RESETHASH]: Short hash..."
HASH="$2"
HASH=${HASH:0:64}

echo "[CODEX_CLI][RESETHASH]: Default password hash..."
docker rm -f codexcli-reset-hash-helper > /dev/null 2>&1
DEFAULT_PASS="$(
    docker run -it --rm \
        --name "codexcli-reset-hash-helper" \
        -v "$CODEX_USER_DATA/.codex:/app" \
        ubuntu:22.04 \
            bash -c \
            "cat /app/hash/$1.hash"
)"

echo "Reset password hash to: '$DEFAULT_PASS'"

$CURRENT_DIR/passhash.sh $1 "$DEFAULT_PASS"

echo "[CODEX_CLI][RESETHASH]: Default password hash set!"
