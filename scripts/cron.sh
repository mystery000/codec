#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

$CURRENT_DIR/uncron.sh

sudo mkdir -p $CURRENT_DIR/.codex/cron
sudo rm -rf $CODEX_USER_DATA/.codex/cron/*
sudo cp $CURRENT_DIR/../cron/* $CODEX_USER_DATA/.codex/cron/

sudo crontab -l > /tmp/codex-cron
sudo echo "50 4 * * * $CODEX_USER_DATA/.codex/cron/task.sh $USER" >> /tmp/codex-cron
sudo crontab /tmp/codex-cron
sudo rm -rf /tmp/codex-cron
