#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][DOCKERD_PROCESS]: No codex user defined!"
    exit 1
fi

echo "[CODEX_CLI][DOCKERD_PROCESS]: Start docker daemon..."

CODEX_USER=$1
CODEX_DOCKERD_DIR="$CODEX_USER_DATA/.codex/dockerd/"
CODEX_DOCKERD_CONFIG_PATH="$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd_config.json"

dockerd \
    --config-file "$CODEX_DOCKERD_CONFIG_PATH" > \
    "$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd.logs" \
    2>&1 &
    
CODEX_DOCKERD_PID=$!

while docker ps -q --filter name=codex_$CODEX_USER &> /dev/null; do
    sleep 30
done

$CURRENT_DIR/dockerd-stop.sh $CODEX_USER
kill -s SIGKILL $CODEX_DOCKERD_PID

echo "[CODEX_CLI][DOCKERD_PROCESS]: dockerd exit!"
