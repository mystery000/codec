#!/usr/bin/env bash

if [ -z "$CODEX_NET" ]; then
    export CODEX_NET="codex_net"
fi

if [ -z "$CODEX_BIN_INSTALL_PATH" ]; then
    export CODEX_BIN_INSTALL_PATH="/usr/bin"
fi

export CURRENT_DIR=$(dirname $(realpath $0))
export CODEX_CLI_PATH=$(realpath "$CURRENT_DIR/../codexcli")

if [ -z "$CODEX_USER_DATA" ]; then
    export CODEX_USER_DATA="$CURRENT_DIR/../codex-data"
fi
