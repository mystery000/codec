#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][DOCKERD]: No codex user defined!"
    exit 1
fi

echo "[CODEX_CLI][DOCKERD]: Prepare $CODEX_USER docker daemon process..."

CODEX_USER=$1
CODEX_DOCKERD_DIR="$CODEX_USER_DATA/.codex/dockerd/"
CODEX_DOCKERD_CONFIG_PATH="$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd_config.json"
CODEX_DOCKERD_PID_PATH="$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd.pid"

mkdir -p $CODEX_DOCKERD_DIR
mkdir -p $CODEX_USER_DATA/$CODEX_USER/dockerd/

$CURRENT_DIR/dockerd-stop.sh $CODEX_USER

cat <<EOF > $CODEX_DOCKERD_CONFIG_PATH
{
  "hosts": ["unix://$CODEX_USER_DATA/$CODEX_USER/dockerd/dockerd.sock"],
  "pidfile": "$CODEX_DOCKERD_DIR/$CODEX_USER_dockerd.pid",
  "data-root": "$CODEX_USER_DATA/$CODEX_USER/dockerd/data",
  "registry-mirrors": [
    "https://docker-reg.coreunit.net"
  ],
  "storage-driver": "vfs",
  "debug": true,
  "log-driver": "json-file",
  "log-opts": {
  "max-size": "12m",
  "max-file": "3"
}
EOF

echo "[CODEX_CLI][DOCKERD]: Run $CODEX_USER docker daemon process..."
$CURRENT_DIR/dockerd-process.sh $CODEX_USER > "$CODEX_DOCKERD_DIR/$CODEX_USER_docker_sidecar.logs" &