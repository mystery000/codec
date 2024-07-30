#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

if [ -z "$1" ]; then
    echo "[CODEX_CLI][LOGS]: No codec user defined!"
    exit 1
fi

echo "[CODEX_CLI][LOGS]: Sysdemd logs of '$1':"
docker logs "codec_$1"
echo "[CODEX_CLI][LOGS]: Codec boot logs of '$1':"
docker exec -it "codec_$1" codec -l
