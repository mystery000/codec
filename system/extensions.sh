#!/usr/bin/env bash

echo "[CODEX][EXTENSION]: Set vscode extension store..." 
export VSCODE_GALLERY=ms2
/etc/codex/vscode_gallery.js

echo "[CODEX][EXTENSION]: Install default extensions..." 

codei pkief.material-icon-theme 
codei pinage404.git-extension-pack 
codei ms-python.python 
codei mhutchie.git-graph 
codei genuitecllc.codetogether