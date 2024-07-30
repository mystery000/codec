#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

cd $CURRENT_DIR/..

echo "The newest coder/code-server version is: $(./fetch-code-server-version.js)"

FLAG_NAME="--scratch"
FLAG_SHORTNAME="-s"
if [ "$1" == "$FLAG_NAME" ] ||  [ "$1" == "$FLAG_SHORTNAME" ]  ||
    [ "$2" == "$FLAG_NAME" ] ||  [ "$2" == "$FLAG_SHORTNAME" ]  ||
    [ "$3" == "$FLAG_NAME" ] ||  [ "$3" == "$FLAG_SHORTNAME" ]  ||
    [ "$4" == "$FLAG_NAME" ] || [ "$5" == "$FLAG_NAME" ] ||
    [ "$6" == "$FLAG_NAME" ] || [ "$7" == "$FLAG_NAME" ] ||
    [ "$4" == "$FLAG_SHORTNAME" ] || [ "$5" == "$FLAG_SHORTNAME" ] ||
    [ "$6" == "$FLAG_SHORTNAME" ] || [ "$7" == "$FLAG_SHORTNAME" ]; then
    echo "[CODEX_CLI][BUILD]: Build codec image form scratch..."

    docker build \
        --pull \
        --no-cache \
        -t codex \
        .

    echo "[CODEX_CLI][BUILD]: Scratch image ready!"
    echo 0
fi



echo "[CODEX_CLI][BUILD]: Build codec image..."

docker build \
    -t codex \
    .

echo "[CODEX_CLI][BUILD]: Image ready!"
