#!/bin/bash
set -e

#
# Deploy script for morebooks.ml
#


# Configuration
CONTROL="/usr/sbin/systemctl"
SERVER="apache"
WORKDIR=$(dirname "$0")


# Stop web server to release all locks it might have imposed
$CONTROL stop $SERVER


# Update HomeLibraryCatalog to the latest git version
pip uninstall -y HomeLibraryCatalog
pip install -r "$WORKDIR/requirements.txt"


# Back up valuable data
python3 "$WORKDIR/backup.py"


# Restart the web server
$CONTROL start $SERVER
