#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

echo "Need root access..."
sudo echo "Root access granted!"

sudo crontab -l > /tmp/codex-cron
sed '/.codex/d' /tmp/codex-cron > /tmp/codex-cron
sudo crontab /tmp/codex-cron
sudo rm -rf /tmp/codex-cron
