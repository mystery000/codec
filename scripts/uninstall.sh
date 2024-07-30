#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

echo "[CODEX_CLI][UNINSTALL]: Need super user rights to uninstall codexcli..."
sudo echo "[CODEX_CLI][UNINSTALL]: Super user access granted!"

if [ "$1" != "-f" ] && [ "$1" != "--force" ]; then
    echo "[CODEX_CLI][UNINSTALL]: Uninstall codexcli?"
    echo "If you want to uninstall codex enter 'y'."
    read INPUT_VALUE
    if [ "$INPUT_VALUE" != "y" ]; then
        echo "Abort uninstall!"
        exit 1
    fi
fi

echo "[CODEX_CLI][UNINSTALL]: Uninstall codexcli..."
sudo rm -rf $CODEX_BIN_INSTALL_PATH/codexcli

echo "[CODEX_CLI][UNINSTALL]: Done!"
