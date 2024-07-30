#!/usr/bin/env bash

CURRENT_DIR=$(dirname $(realpath $0))

UPDATE_START="$(date +'%Y_%m_%d_%H_%M')"

if [ -z "$CODEX_USER_DATA" ]; then
    CODEX_USER_DATA="/var/lib/codex"
fi

sudo rm -rf $CODEX_USER_DATA/.codex/$UPDATE_START.log
($CURRENT_DIR/update.sh $1 $UPDATE_START) >> $CODEX_USER_DATA/.codex/$UPDATE_START.log
