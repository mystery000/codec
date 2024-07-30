#!/usr/bin/env bash

if [ -z "$CODEX_NET" ]; then
    export CODEX_NET="codex_net"
fi

if [ -z "$CODEC_BIN_INSTALL_PATH" ]; then
    export CODEC_BIN_INSTALL_PATH="/usr/bin"
fi

export CURRENT_DIR=$(dirname $(realpath $0))
export CODEC_CLI_PATH=$(realpath "$CURRENT_DIR/../codexcli")

if [ -z "$CODEC_USER_DATA" ]; then
    export CODEC_USER_DATA="$CURRENT_DIR/../codec-data"
fi
