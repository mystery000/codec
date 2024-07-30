#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

$CURRENT_DIR/build.sh > /dev/null 2>&1 &
BUILD_PID=$!

echo "[CODEX_CLI][RERIGHT]: Reset user rights on .codec folder..."
docker run -it --rm \
    --name "codexcli-reright" \
    -v "$CODEC_USER_DATA/.codec:/app" \
    ubuntu:22.04 \
        bash -c \
            "chown -R root /app"

docker run -it --rm \
            --name "codexcli-start-port-reader" \
            -v "$CODEC_USER_DATA/.codec:/app" \
            ubuntu:22.04 \
                bash
