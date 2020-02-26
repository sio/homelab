#!/bin/bash
#
# Show which Ansible roles are not listed in documentation
#
set -eo pipefail


SCRIPT_DIR="$(dirname "$0")"
ROLE_DIR="$SCRIPT_DIR/../roles"
README="$SCRIPT_DIR/../README.md"
ROLE_FORMAT="**%s**"


rc=0
for role in "$ROLE_DIR"/*
do
    role="${role##*/}"  # basename
    if ! grep -q -- "$(printf -- "$ROLE_FORMAT" "$role")" "$README"
    then
        echo "$README: role '$role' missing"
        rc=1
    fi
done
exit $rc
