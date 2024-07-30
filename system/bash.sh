#!/usr/bin/env bash 

source /etc/environment

codex -w

MODS_PATH="/codex/.codex/enabled-mods"
BASH_MOD_PATHS=("$(find $MODS_PATH -name "*.bash.sh")")

for BASH_MOD_PATH in $BASH_MOD_PATHS; do
    source $BASH_MOD_PATH
done