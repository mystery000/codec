# CodeX
- [CodeX](#codex)
- [About](#about)
- [Warning](#warning)
  - [Warning for Compute/Software/Hosting](#warning-for-computesoftwarehosting)
  - [Warning for Storage/Cloud/Database](#warning-for-storageclouddatabase)
- [Ecosystem](#ecosystem)
  - [Container](#container)
  - [Breakout](#breakout)
- [Persistent data](#persistent-data)
  - [Software](#software)
  - [Data](#data)
  - [Benefits](#benefits)
- [Features](#features)
  - [Mods](#mods)
  - [Mounts](#mounts)
  - [Docker](#docker)
  - [Systemd](#systemd)
  - [Commands](#commands)
    - [Examples](#examples)
  - [Custom commands](#custom-commands)
      - [Command examples:](#command-examples)

# About
Codex is a `visual studio code` docker container designed for development from anywhere `from any web browser` with some additional development features.

# Warning
Codex is not a server hosting or cloud service.

## Warning for Compute/Software/Hosting
It is allowed to use software on the released ports ("/codex/.codex/ports.into.txt").

Other software may not be run for more than 8 hours without an interruption of at least half of the runtime.
That means a break of at least 4 hours after 8 hours, a break of at least 3 hours after 6 hours and a break of at least 1 hour after 2 hours.

## Warning for Storage/Cloud/Database
Also its not allowed to use codex as place to store data.
Please try not to use more than 1 GB.
if you exceed this limit, we will contact you before we delete anything. 

If the container uses more than 4 GB, we may look into the container's data and delete folders and files without asking and warning again.

# Ecosystem

## Container
Codex runs inside a linux container. this is something like a virtual machine.

## Breakout
Breaking out of this container is prevented by mechanisms, but is still not permitted.

# Persistent data
Codex can only store data in the `/codex` folder.
Data saved outside of this folder will not be saved after a codex restart.

If a mysql database is installed and the data folder is not in `/codex`, the DBMS and  the database is deleted after a restart of the codex container.

If software and its data needs to be stored persistently, then follow the [Software](#Software) and [Data](#Data) steps.

## Software
No software should be installed in the `/codex` folder.
Software should be installed either through the `/codex/.codex/boot.sh` bash script or through a codex Mod.
Codex Mods are explained in [Mods](#mods) below.

## Data
Any software data such as databases, configurations and custom-source-code should be stored somewhere in the `/codex` directory.
Excluded from this is any software available online on the internet and also its source code.

## Benefits
Following the `Persistent data` rules has several benefits for both user and codex host.

Because only data is stored in the `/codex` folder, restoring, starting, moving and backing up a codex container is quick and easy.

In the event of an error or if software is no longer required, the software can be removed immediately and completely by restarting the container.

All data that is stored persistently is determined by the user and not by the software.

# Features

## Mods
Software should be installed either through the `/codex/.codex/boot.sh` bash script or through a Mod in the `/codex/.codex/enabled-mods` folder.
There are already some Mods in the `/codex/.codex/mods` folder as a template for your own Mods.
with the command `codex modon` you can switch Mods on and with `codex modoff` you can switch them off.

## Mounts
This `/codex/.codex/mounts.json` mounts configuration exists to persist folders that are distributed on the system.
The key-value object in this json file uses as a key the file or folder which is located under `/codex/mounts/${KEY}` and the folder which should be linked there.
Because the link points to `/codex/mounts/*`, all data will be stored permanently because they are located in the `/codex` folder.

## Docker
The codex docker image supports `dind` ("Docker in Docker"), which means `docker can be used` within the codex container if the host wants to support it.

Use `codex modon docker` to enable dockerd.

## Systemd
The first thing the codex container starts is systemd.

Systemd is a software suite that provides an array of system components for Linux operating systems.
Its main aim is to unify service configuration and behavior across Linux distributions.

Systemd manages some services like `vscode-server`, `docker` services and also the own `codex service` which are important for the codex ecosystem.

## Commands
Codex comes with some of its own commands which make it easier to use codex and can change some settings.
An example is the `codex` command which you should test with `codex --help`.
### Examples
 - codex (codex main command)
 - code (vscode code command)
 - codexlogs (shows codex service logs)

## Custom commands
Codex allows you to place your own commands in the `/codex/.codex/bin` folder.
These can then be used in the command line.

There are already some helpful commands that are not required for the codex ecosystem.
#### Command examples:
 - aptup (apt system update, upgrade, autoremove and clean up)
 - gin (shows curren git branche and file changes)
 - gundo (shows and undo the last commit if you press enter)
 - eclean (can free some disk space in emergency)

[Back to top](#codex)