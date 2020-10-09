#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


# Limit access to any file created by this script
umask 0077


# Check that required environment variables are defined
[[ -z "$ANSIBLE_VAULT_KEYNAME" ]] && { echo ANSIBLE_VAULT_KEYNAME is not defined; exit 104; }
[[ -z "$DISPLAY" ]] && { echo DISPLAY is not defined; exit 104; }
[[ -z "$INVENTORY" ]] && { echo INVENTORY is not defined; exit 104; }
[[ -z "$SECRETS_TIMEOUT_SECONDS" ]] && { echo SECRETS_TIMEOUT_SECONDS is not defined; exit 104; }
[[ -z "$SSH_ASKPASS" ]] && { echo SSH_ASKPASS is not defined; exit 104; }
[[ -z "$SSH_AUTH_SOCK" ]] && { echo SSH_AUTH_SOCK is not defined; exit 104; }
[[ -z "$SSH_KEYS" ]] && { echo SSH_KEYS is not defined; exit 104; }


# Load SSH keys into agent
#
# For non-interactive password pipe to work
# DISPLAY and SSH_ASKPASS environment variables must be provided
for IDENTITY in $SSH_KEYS
do
    while true
    do
        echo -n $(systemd-ask-password "Enter passphrase for $IDENTITY:") \
        |  ssh-add -t "$SECRETS_TIMEOUT_SECONDS" "$IDENTITY" \
        && break
    done
done


# Load Ansible Vault password into kernel keyring
#
# ANSIBLE_VAULT_KEYNAME must be provided by environment
FIFO=$(mktemp -u --tmpdir 'control-secrets-init-XXXXXXX' 2>/dev/null)
mkfifo -m 600 "$FIFO"
while true
do
    VAULT_PASS=$(systemd-ask-password "Enter Ansible Vault password:")
    echo -n "$VAULT_PASS" > "$FIFO" &
    ansible-vault decrypt "$INVENTORY" --vault-password-file="$FIFO" --output=/dev/null || continue

    KEY_ID=$(keyctl add user "$ANSIBLE_VAULT_KEYNAME" dummy-value @u)
    keyctl setperm "$KEY_ID" 0x003f0000
    keyctl timeout "$KEY_ID" "$SECRETS_TIMEOUT_SECONDS"
    echo -n "$VAULT_PASS" | keyctl pupdate "$KEY_ID"
    break
done
rm "$FIFO" || true
