#!/usr/bin/env bash

echo "[CODEX_CLI]: Crontask Update-All"
echo "AT: $2"
echo "--------------------------------"

sudo -u "$1" -s bash -c 'codexcli build -s; codexcli updateall -f'
