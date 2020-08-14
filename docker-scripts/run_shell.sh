#!/bin/sh
mkdir -p /data/yottadb
mkdir -p /data/yottadb/g
mkdir -p /data/yottadb/r
mkdir -p /data/yottadb/o

$HOME/scripts/yotta_config
tmux
