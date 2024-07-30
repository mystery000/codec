#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

echo "[CODEX_CLI][INSTALL]: Need super user rights to install codexcli..."
sudo echo "[CODEX_CLI][INSTALL]: Super user access granted!"

echo "test: $CODEC_BIN_INSTALL_PATH/codexcli"
echo "test2: $CODEX_CLI_PATH $CODEC_BIN_INSTALL_PATH/codexcli"

echo "[CODEX_CLI][INSTALL]: Install codexcli..."
sudo rm -rf $CODEC_BIN_INSTALL_PATH/codexcli
sudo ln -s $CODEX_CLI_PATH $CODEC_BIN_INSTALL_PATH/codexcli

if [ "$1" != "-i" ] && [ "$1" != "--image" ]; then
    echo "[CODEX_CLI][INSTALL]: Build codec image?"
    echo "If you also want to build and cache the newest codec image enter 'y'."
    read INPUT_VALUE
    if [ "$INPUT_VALUE" == "y" ]; then
        $CURRENT_DIR/build.sh -s
    fi
fi

echo "[CODEX_CLI][INSTALL]: Done!"
