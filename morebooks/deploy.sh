#!/bin/bash
set -e

#
# Deploy script for morebooks.ml
#


# Configuration
CONTROL="sudo systemctl"
SERVER="apache2"
WORKDIR=$(dirname "$0")


# Stop web server to release all locks it might have imposed
$CONTROL stop $SERVER


# Update HomeLibraryCatalog to the latest git version
set +e  # ignore uninstall errors
pip3 uninstall -y HomeLibraryCatalog
set -e
pip3 install --user -r "$WORKDIR/requirements.txt"


# Back up valuable data
python3 "$WORKDIR/backup.py"


# Start the web server
$CONTROL start $SERVER
