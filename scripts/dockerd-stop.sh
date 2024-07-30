#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][DOCKERD_STOP]: No codex user defined!"
    exit 1
fi

CODEX_USER=$1
CODEX_DOCKERD_DIR="$CODEX_USER_DATA/.codex/dockerd/"
CODEX_DOCKERD_CONFIG_PATH="$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd_config.json"
CODEX_DOCKERD_PID_PATH="$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd.pid"

if [ ! -f "$CODEX_DOCKERD_PID_PATH" ]; then
    echo "[CODEX_CLI][DOCKERD_STOP]: No $CODEX_USER dockerd started for $CODEX_USER!"
    exit 0
fi

CODEX_DOCKERD_PID=$(<"$CODEX_DOCKERD_PID_PATH")

echo "[CODEX_CLI][DOCKERD_STOP]: Exit $CODEX_USER dockerd graceful..."
kill -s SIGTERM $CODEX_DOCKERD_PID

GRACEFUL_COUNTER=0

while ps -p $CODEX_DOCKERD_PID > /dev/null; do
    if [ $GRACEFUL_COUNTER -ge 10 ]; then
        echo "[CODEX_CLI][DOCKERD_STOP]: No graceful exit!"
        kill -s SIGKILL $CODEX_DOCKERD_PID
        break
    fi
    sleep 2
    GRACEFUL_COUNTER=$((GRACEFUL_COUNTER + 1))
done

echo "[CODEX_CLI][DOCKERD_STOP]: $CODEX_USER dockerd exit!"