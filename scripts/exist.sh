#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][EXIST]: No codex user defined!"
    exit 1
fi

CODEX_USERS="$(
docker run -it --rm \
    -v "$CODEX_USER_DATA:/app" \
    -w /app \
    ubuntu:22.04 \
        ls -AQ
)"

if [[ $CODEX_USERS != *"\"$1\""* ]]; then
    echo "false"
    exit 1
fi

if [ "$2" == "CODEXDIR" ]; then
    CODEX_DIR="$(
        docker run -it --rm \
            -v "$CODEX_USER_DATA/$1:/app" \
            -w /app \
            ubuntu:22.04 \
                ls -AQ
    )"
    if [[ $CODEX_DIR != *"\".codex\""* ]]; then
        echo -n "false"
        exit 1
    fi
fi

echo -n "true"
exit 0
