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


# Load Ansible Vault password into kernel keyring
#
# ANSIBLE_VAULT_KEYNAME must be provided by environment
# This query must come first to give time for ssh-agent to initialize properly
FIFO=$(mktemp -u --tmpdir 'control-secrets-init-XXXXXXX' 2>/dev/null)
mkfifo -m 600 "$FIFO"
echo "Saving Ansible Vault password for $INVENTORY..."
while true
do
    VAULT_PASS=$(systemd-ask-password --timeout=0 "Enter Ansible Vault password:")
    echo -n "$VAULT_PASS" > "$FIFO" &
    ansible-vault decrypt "$INVENTORY" --vault-password-file="$FIFO" --output=/dev/null \
    || {
        echo Incorrect password, retrying...
        continue
    }

    # Dancing around keyctl setperm: https://mjg59.dreamwidth.org/37333.html
    KEY_ID=$(keyctl add user "$ANSIBLE_VAULT_KEYNAME" dummy-value @s)
    keyctl setperm "$KEY_ID" 0x3f3f0000
    keyctl link "$KEY_ID" @u
    keyctl unlink "$KEY_ID" @s
    keyctl timeout "$KEY_ID" "$SECRETS_TIMEOUT_SECONDS"

    # Save password to kernel keyring
    echo -n "$VAULT_PASS" | keyctl pupdate "$KEY_ID"
    break
done
rm "$FIFO" || true


# Load SSH keys into agent
#
# For non-interactive password pipe to work
# DISPLAY and SSH_ASKPASS environment variables must be provided
for IDENTITY in $SSH_KEYS
do
    echo "Adding $IDENTITY to ssh-agent..."
    while true
    do
        echo -n $(systemd-ask-password --timeout=0 "Enter passphrase for $IDENTITY:") \
        |  ssh-add -t "$SECRETS_TIMEOUT_SECONDS" "$IDENTITY" \
        && break
        echo "Incorrect passphrase, retrying..."
    done
done
