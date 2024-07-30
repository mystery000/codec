#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

$CURRENT_DIR/build.sh > /dev/null 2>&1 &
BUILD_PID=$!

DOCKER_START_CMD=" \
    docker run -it \
        --name 'codexcli_test' \
        --net '$CODEX_NET' \
        -e 'CODEC_PORTS=NONE-TEST-CONTAINER' \
        codex \
        /bin/bash \
"

echo "[CODEX_CLI][TEST]: Docker run command preview: '"
echo "$DOCKER_START_CMD"
echo "'"

echo "[CODEX_CLI][TEST]: Wait for image building..."
while kill -0 $BUILD_PID >/dev/null 2>&1; do
    sleep 1
done
echo "[CODEX_CLI][TEST]: Image ready!"

docker rm -f codexcli_test > /dev/null 2>&1
docker network create "$CODEX_NET" > /dev/null 2>&1

echo "[CODEX_CLI][TEST]: Run docker container..."
bash -c "$DOCKER_START_CMD"

#echo "[CODEX_CLI][TEST]: Run docker daemon..."
#$CURRENT_DIR/dockerd.sh $CODEC_USER

echo "[CODEX_CLI][TEST]: Finished!"
