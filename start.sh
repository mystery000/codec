#!/usr/bin/env bash

./codexcli build -s

./codexcli start tester 30000 0 -f
