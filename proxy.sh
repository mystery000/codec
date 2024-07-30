#!/usr/bin/env bash

if [ -z "$CODEX_NET" ]; then
    CODEX_NET="codex_net"
fi

docker pull majo418/cprox

docker rm -f "codex_proxy" > /dev/null 2>&1
docker network create "$CODEX_NET" > /dev/null 2>&1

docker run -itd --rm \
    --name "codex_proxy" \
    -p 80:80 \
    -p 443:443 \
    --net "$CODEX_NET" \
    -v /home/netde/static/main:/var/www/html \
    -v /home/netde/certs/coreunit.net:/app/certs \
    -e CERT_PATH="/app/certs" \
    -e CERT_NAME="cert1.pem" \
    -e KEY_NAME="privkey1.pem" \
    -e CA_NAME="fullchain1.pem" \
    -e VERBOSE="true" \
    majo418/cprox \
        "/app/dist/index.js" \
        "discord.coreunit.net=REDIRECT:https://discord.gg/pwHNaHRa9W" \
        "*.codec.coreunit.net=PROXY:http://codec_{-4}:8080" \
        "majo.coreunit.net=REDIRECT:https://github.com/majo418" \
        "coreunit.net=REDIRECT:https://discord.gg/pwHNaHRa9W"

echo "### Proxy is running..."
echo "(Check proxy with 'docker logs codex_proxy')"
