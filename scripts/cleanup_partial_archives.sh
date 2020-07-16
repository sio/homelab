#!/bin/bash
set -eo pipefail

ARCHIVE_TYPE=tar.xz

echo "THIS SCRIPT WILL REMOVE ALL INVALID $ARCHIVE_TYPE FILES IN CURRENT DIRECTORY"
echo "Press Enter to proceed, Ctrl+C to cancel"
read

for filename in *.$ARCHIVE_TYPE
do
    tar -tf "$filename" &>/dev/null || rm -v "$filename"
done
