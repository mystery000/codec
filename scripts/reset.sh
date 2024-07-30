#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][RESET]: No codex user defined!"
    exit 1
fi

if [ "$2" != "-f" ] && [ "$2" != "--force" ]; then
    echo "[CODEX_CLI][RESET]: Reset codex user data of '$1'?"
    echo "Type 'y' to delete the codex user '$1'"
    echo "Userdata at:'$CODEX_USER_DATA/$1/.codex'"
    read INPUT_VALUE
    if [ "$INPUT_VALUE" != "y" ]; then
        echo "Abort because input was not 'y'!"
        exit 1
    fi
fi

$CURRENT_DIR/close.sh "$1"

echo "Delete '/codex/.codex' for '$1'..."
docker run -it --rm \
    -v "$CODEX_USER_DATA/$1:/app" \
    ubuntu:22.04 \
        bash -c 'mv "/app/.codex/vscode-server.yaml" "/vscode-server.yaml" \
        && rm -rf "/app/.codex/*" \
        && mv "/vscode-server.yaml" "/app/.codex/"'

