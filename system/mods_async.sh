#!/usr/bin/env bash

echo "[CODEX][MOD]: Load mods..."

ENABLED_MODS_PATH="/codex/.codex/enabled-mods"
OPTIONAL_MODS_PATH="/codex/.codex/mods"
LOGS_PATH="/etc/codex/logs"

ASYNC_MOD_PATHS=("$(find $ENABLED_MODS_PATH -name "*.async.sh")")

for ASYNC_MOD_PATH in $ASYNC_MOD_PATHS; do
    ASYNC_MOD_NAME=$(basename "$ASYNC_MOD_PATH")
    ASYNC_MOD_LOGS_PATH=$LOGS_PATH/mod.$ASYNC_MOD_NAME.async.log
    echo "[CODEX][MOD][ASYNC]: Start '$ASYNC_MOD_NAME' async..."
    touch $ASYNC_MOD_LOGS_PATH
    $ASYNC_MOD_PATH &> $ASYNC_MOD_LOGS_PATH
    echo "Started $ASYNC_MOD_NAME async in background!"
done
