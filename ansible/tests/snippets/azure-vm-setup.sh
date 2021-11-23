#!/bin/bash
#
# Setup Azure one-off VM for Ansible/Molecule development
#
set -euo pipefail
IFS=$'\n\t'

ROOT=$(readlink -m "$0/../../../..")

filter='
    BEGIN {
        show = 0;
    }
    /apt-get install/ {
        show = 1;
        next;
    }
    /^[ \t]*&&/ {
        show = 0;
    }
    /./ {
        if (show == 1) {
            print $1
        }
    }
'
packages=$(cat "$ROOT/ansible/tests/Dockerfile.host"* | awk "$filter")
apt update
apt install -y --no-install-recommends $packages

groups=$(grep 'groups: ' "$ROOT/ansible/lab.yml" | awk '{ print $2 }')
if [[ "$USER" != "root" ]]
then
    usermod -aG "$groups" "$USER"
fi
