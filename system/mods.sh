#!/usr/bin/env bash

echo "[CODEX][MOD]: Load mods..."

ENABLED_MODS_PATH="/codex/.codex/enabled-mods"
OPTIONAL_MODS_PATH="/codex/.codex/mods"
LOGS_PATH="/etc/codex/logs"

mkdir -p $ENABLED_MODS_PATH
mkdir -p $OPTIONAL_MODS_PATH
mkdir -p $LOGS_PATH

ENV_MOD_PATHS=("$(find $ENABLED_MODS_PATH -name "*.env.sh")")
BOOT_MOD_PATHS=("$(find $ENABLED_MODS_PATH -name "*.boot.sh")")
ASYNC_MOD_PATHS=("$(find $ENABLED_MODS_PATH -name "*.async.sh")")
BASH_MOD_PATHS=("$(find $ENABLED_MODS_PATH -name "*.bash.sh")")
QUIT_MOD_PATHS=("$(find $ENABLED_MODS_PATH -name "*.quit.sh")")

MOD_COUNTER=0

for MOD_PATH in $ENV_MOD_PATHS; do
    chmod +x $MOD_PATH
    MOD_COUNTER=$(($MOD_COUNTER+1))
done
for MOD_PATH in $BOOT_MOD_PATHS; do
    chmod +x $MOD_PATH
    MOD_COUNTER=$(($MOD_COUNTER+1))
done
for MOD_PATH in $ASYNC_MOD_PATHS; do
    chmod +x $MOD_PATH
    MOD_COUNTER=$(($MOD_COUNTER+1))
done
for MOD_PATH in $BASH_MOD_PATHS; do
    chmod +x $MOD_PATH
    MOD_COUNTER=$(($MOD_COUNTER+1))
done
for MOD_PATH in $QUIT_MOD_PATHS; do
    chmod +x $MOD_PATH
    MOD_COUNTER=$(($MOD_COUNTER+1))
done

if [[ "$1" == "-q" || "$1" == "--quit" || "$1" == "quit" ]]; then
    for QUIT_MOD_PATH in $QUIT_MOD_PATHS; do
        QUIT_MOD_NAME=$(basename "$QUIT_MOD_PATH")
        QUIT_MOD_LOGS_PATH=$LOGS_PATH/mod.$QUIT_MOD_NAME.quit.log
        echo "[CODEX][MOD][QUIT]: Load '$QUIT_MOD_NAME' for quit"
        touch $QUIT_MOD_LOGS_PATH
        source $QUIT_MOD_PATH > $QUIT_MOD_LOGS_PATH
        echo "[CODEX][MOD][QUIT]: '$QUIT_MOD_NAME' loaded!"
    done

    echo "[CODEX][MOD][QUIT]: All finished!"

    exit 0
fi

echo "[CODEX][MOD]: $MOD_COUNTER mods found!"

export CODEX_ALL_APT_PACKAGES=""
export CODEX_ALL_NPM_PACKAGES=""
source /codex/.codex/env.sh > $LOGS_PATH/user.env.log

for ENV_MOD_PATH in $ENV_MOD_PATHS; do
    ENV_MOD_NAME=$(basename "$ENV_MOD_PATH")
    ENV_MOD_LOGS_PATH=$LOGS_PATH/mod.$ENV_MOD_NAME.env.log
    echo "[CODEX][MOD][ENV]: Load '$ENV_MOD_NAME' env"
    touch $ENV_MOD_LOGS_PATH
    source $ENV_MOD_PATH > $ENV_MOD_LOGS_PATH
    echo "[CODEX][MOD][ENV]: '$ENV_MOD_NAME' loaded!"
    if [ "$CODEX_APT_PACKAGES" != "" ]; then
        if [ "$CODEX_ALL_APT_PACKAGES" != "" ]; then
            export CODEX_ALL_APT_PACKAGES="$CODEX_ALL_APT_PACKAGES $CODEX_APT_PACKAGES"
        else
            export CODEX_ALL_APT_PACKAGES="$CODEX_APT_PACKAGES"
        fi
        
        export CODEX_APT_PACKAGES=""
    fi
    if [ "$CODEX_NPM_PACKAGES" != "" ]; then
        if [ "$CODEX_ALL_NPM_PACKAGES" != "" ]; then
            export CODEX_ALL_NPM_PACKAGES="$CODEX_ALL_NPM_PACKAGES $CODEX_NPM_PACKAGES"
        else
            export CODEX_ALL_NPM_PACKAGES="$CODEX_NPM_PACKAGES"
        fi
        
        export CODEX_NPM_PACKAGES=""
    fi
done

apt-get update
if [ "$CODEX_ALL_APT_PACKAGES" != "" ]; then
    echo "[CODEX][MOD][APT]: Install following packages:"
    echo "'$CODEX_ALL_APT_PACKAGES'"
    apt-get install -y --no-install-recommends $CODEX_ALL_APT_PACKAGES
else 
    echo "[CODEX][MOD][APT]: No apt packages defined!"
fi

if [ "$CODEX_ALL_NPM_PACKAGES" != "" ]; then
    echo "[CODEX][MOD][NPM]: Install following packages:"
    echo "'$CODEX_ALL_NPM_PACKAGES'"
    npm i -g $CODEX_ALL_NPM_PACKAGES
else 
    echo "[CODEX][MOD][NPM]: No npm packages defined!"
fi

for BOOT_MOD_PATH in $BOOT_MOD_PATHS; do
    BOOT_MOD_NAME=$(basename "$BOOT_MOD_PATH")
    BOOT_MOD_LOGS_PATH=$LOGS_PATH/mod.$BOOT_MOD_NAME.boot.log
    echo "[CODEX][MOD][BOOT]: Start '$BOOT_MOD_NAME'..."
    touch $BOOT_MOD_LOGS_PATH
    $BOOT_MOD_PATH > $BOOT_MOD_LOGS_PATH
    echo "[CODEX][MOD][BOOT]: '$BOOT_MOD_NAME' done!"
done
