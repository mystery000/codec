#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

USER=$1

echo "[CODEX_CLI][ENABLE]: Enable user '$1'..."
docker rm -f codexcli-disable > /dev/null 2>&1
docker run -it --rm \
    --name "codexcli-disable" \
    -v "$CODEX_USER_DATA/:/app" \
    ubuntu:22.04 \
        bash -c \
        "mkdir -p /app/.codex/archive/$1 \
        && mkdir -p /app/$1 \
        && cp -r /app/.codex/archive/$1/* /app/$1/ \
        && rm -rf /app/.codex/archive/$1"

