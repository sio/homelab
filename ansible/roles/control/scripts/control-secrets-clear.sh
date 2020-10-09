#!/bin/bash

# Clear saved identities from ssh-agent
ssh-add -D

# Clear remembered password from keyring
[[ -z "$ANSIBLE_VAULT_KEYNAME" ]] && { echo ANSIBLE_VAULT_KEYNAME is not defined; exit 104; }
keyctl purge user "$ANSIBLE_VAULT_KEYNAME"
