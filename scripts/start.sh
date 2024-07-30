#!/usr/bin/env bash

export CURRENT_DIR=$(dirname $(realpath $0))
source $CURRENT_DIR/vars.sh

$CURRENT_DIR/build.sh > /dev/null 2>&1 &
BUILD_PID=$!

if [ -z "$1" ]; then
    echo "[CODEX_CLI][START]: No codex user defined!"
    exit 1
fi

CODEX_USER="$1"

if [ -z "$MAX_ALLOED_CODEX_PORTs" ]; then
    MAX_ALLOED_CODEX_PORTS=99
fi

if [ -z "$DEFAULT_CODEX_PORT_COUNT" ]; then
    DEFAULT_CODEX_PORT_COUNT="10"
fi

START_PORT="$2"
PORT_COUNT="$3"
CODEX_PORT="$4"

if (( START_PORT > 65535 )) || (( START_PORT < 1 )); then
    START_PORT=""
fi
if (( PORT_COUNT > $MAX_ALLOED_CODEX_PORTS )) || (( PORT_COUNT < 1 )); then
     PORT_COUNT=""
fi

if [ -z $START_PORT ]; then
    docker rm -f codexcli-start-port-reader > /dev/null 2>&1
    START_PORT="$(
        docker run -it --rm \
            --name "codexcli-start-port-reader" \
            -v "$CODEX_USER_DATA/.codex/ports:/app" \
            ubuntu:22.04 \
                bash -c \
                " \
                    touch /app/$CODEX_USER.start.port && \
                    cat /app/$CODEX_USER.start.port \
                "
    )"
    if [ -z $START_PORT ]; then
        echo "[CODEX_CLI][START]: Start port not defined!"
        exit 1
    fi
fi
echo "[CODEX_CLI][START]: Defined start port is:"
echo "'$START_PORT'"

if [ -z $PORT_COUNT ]; then
    docker rm -f codexcli-end-port-reader > /dev/null 2>&1

    PORT_COUNT="$(
        docker run -it --rm \
            --name "codexcli-end-port-reader" \
            -v "$CODEX_USER_DATA/.codex/ports:/app" \
            ubuntu:22.04 \
                bash -c \
                "touch /app/$CODEX_USER.count.port && cat /app/$CODEX_USER.count.port"
        )"
    if [ -z $PORT_COUNT ]; then
        PORT_COUNT="$DEFAULT_CODEX_PORT_COUNT"
    fi
fi

echo "[CODEX_CLI][START]: Defined port count is:"
echo "'$PORT_COUNT'"

if (( START_PORT > 65535 )); then
    echo "[CODEX_CLI][START]: The start port '$START_PORT' is not in the port range (1-65535)!"
    exit 1
fi
if (( START_PORT < 1 )); then
    echo "[CODEX_CLI][START]: The start port '$START_PORT' is not in the port range (1-65535)!"
    exit 1
fi
if (( PORT_COUNT > $MAX_ALLOED_CODEX_PORTS )); then
    echo "[CODEX_CLI][START]: The port count '$PORT_COUNT' is greater then the maximum allowed count of ports '$MAX_ALLOED_CODEX_PORTS'!"
    exit 1
fi
if (( PORT_COUNT < 1 )); then
    echo "[CODEX_CLI][START]: The port counts needs to be minimum '1'!"
    exit 1
fi

END_PORT=$(($START_PORT+$PORT_COUNT-1))

if (( END_PORT > 65535 )); then
    echo "[CODEX_CLI][START]: The end port '$END_PORT' is not in the port range (1-65535)!"
    exit 1
fi
if (( END_PORT < 1 )); then
    echo "[CODEX_CLI][START]: The end port '$END_PORT' is not in the port range (1-65535)!"
    exit 1
fi

ALREADY_EXIST=$($CURRENT_DIR/exist.sh "$CODEX_USER" "CODEXDIR")

DOCKER_START_CMD=" \
    docker run -d \
        --privileged \
        --name 'codex_$CODEX_USER' \
        --net '$CODEX_NET' \
        --restart unless-stopped \
        -p '0.0.0.0:$CODEX_PORT:8080' \
        -p '0.0.0.0:$START_PORT-$END_PORT:$START_PORT-$END_PORT/tcp' \
        -p '0.0.0.0:$START_PORT-$END_PORT:$START_PORT-$END_PORT/udp' \
        --expose '$START_PORT-$END_PORT' \
        -e 'CODEX_PORTS=$START_PORT-$END_PORT' \
        -e 'CODEX_USER=$CODEX_USER' \
        -v '$CODEX_USER_DATA/.codex/shared_folder:/codex/mounts/shared' \
        -v '$CODEX_USER_DATA/$CODEX_USER:/codex' \
        -v '/home/debian/.config/devopsx:/root/.config/devopsx' \
        codex \
"

echo "[CODEX_CLI][START]: Docker run command preview: '"
echo "$DOCKER_START_CMD"
echo "'"

FLAG_NAME="--force"
FLAG_SHORTNAME="-f"
if [ "$CODEX_USER" != "$FLAG_NAME" ] && [ "$CODEX_USER" != "$FLAG_SHORTNAME" ] &&
    [ "$2" != "$FLAG_NAME" ] && [ "$2" != "$FLAG_SHORTNAME" ] &&
    [ "$3" != "$FLAG_NAME" ] && [ "$3" != "$FLAG_SHORTNAME" ] &&
    [ "$4" != "$FLAG_NAME" ] && [ "$5" != "$FLAG_NAME" ] &&
    [ "$6" != "$FLAG_NAME" ] && [ "$7" != "$FLAG_NAME" ] &&
    [ "$4" != "$FLAG_SHORTNAME" ] && [ "$5" != "$FLAG_SHORTNAME" ] &&
    [ "$6" != "$FLAG_SHORTNAME" ] && [ "$7" != "$FLAG_SHORTNAME" ]; then
    echo ""
    echo "[CODEX_CLI][START]: "
    echo "####### CONTAINER DATA #######"
    echo "#    Ports: '$START_PORT-$END_PORT'"
    echo "# Datapath: '$CODEX_USER_DATA/$CODEX_USER/'"
    echo "#    Exist: '$ALREADY_EXIST'"
    echo "# Enter 'y' to start the '$CODEX_USER' codex user container."
    echo "# [CTRL] + [C] to abort!"
    read INPUT_VALUE
    if [ "$INPUT_VALUE" != "y" ]; then
        echo "Abort because input was not 'y'!"
        exit 1
    fi
fi

echo "[CODEX_CLI][START]: Wait for image building..."
while kill -0 $BUILD_PID >/dev/null 2>&1; do
    sleep 1
done
echo "[CODEX_CLI][START]: Image ready!"

$CURRENT_DIR/close.sh $CODEX_USER

docker network create "$CODEX_NET" > /dev/null 2>&1

echo "[CODEX_CLI][START]: Run docker container..."
bash -c "$DOCKER_START_CMD"

#echo "[CODEX_CLI][START]: Run docker daemon..."
#$CURRENT_DIR/dockerd.sh $CODEX_USER

echo "[CODEX_CLI][START]: Set port user info..."
PORT_INFO_TEXT="Your codex ports: codex.coreunit.net:$START_PORT-$END_PORT"

docker rm -f codexcli-info-helper > /dev/null 2>&1
docker run -it --rm \
    --name "codexcli-info-helper" \
    -v "$CODEX_USER_DATA/$CODEX_USER:/codex" \
    ubuntu:22.04 \
        bash -c \
        " \
        mkdir -p /codex/.codex && \
        chmod 777 /codex/.codex && \
        echo '$PORT_INFO_TEXT' > /codex/.codex/ports.info.txt \
        && chmod 744 /codex/.codex \
        "

echo "[CODEX_CLI][START]: Save startup arguments..."
docker rm -f codexcli-port-helper > /dev/null 2>&1
docker run -it --rm \
    --name "codexcli-port-helper" \
    -v "$CODEX_USER_DATA/.codex:/app" \
    ubuntu:22.04 \
        bash -c \
        " \
        mkdir -p /app/ports \
        && touch /app/ports/$CODEX_USER.start.port \
        && echo -n '$START_PORT' > /app/ports/$CODEX_USER.start.port \
        && touch /app/ports/$CODEX_USER.count.port \
        && echo -n '$PORT_COUNT' > /app/ports/$CODEX_USER.count.port \
        "

if [ "$ALREADY_EXIST" == "false" ]; then
    echo "[CODEX_CLI][START]: Set new random generated password..."
    NEW_DEFAULT_PASS="$($CURRENT_DIR/randompass.sh $CODEX_USER)"
    $CURRENT_DIR/defaultpass.sh $CODEX_USER "$NEW_DEFAULT_PASS"
    $CURRENT_DIR/setpass.sh $CODEX_USER "$NEW_DEFAULT_PASS"

    echo "Default password is: '$NEW_DEFAULT_PASS'"
fi

echo "[CODEX_CLI][START]: Finished!"
