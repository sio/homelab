#!/bin/bash

# Fetch Ansible Vault password from the keyring
[[ -z "$ANSIBLE_VAULT_KEYNAME" ]] && { echo ANSIBLE_VAULT_KEYNAME is not defined; exit 104; }

[[ $(grep -c "$ANSIBLE_VAULT_KEYNAME" /proc/keys) == 1 ]] || {
    echo Can not detect /proc/keys entry for "$ANSIBLE_VAULT_KEYNAME"
    exit 101
}
keyctl print 0x$(grep "$ANSIBLE_VAULT_KEYNAME" /proc/keys|cut -d\  -f1)
