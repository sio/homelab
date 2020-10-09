#!/bin/bash

# Fetch Ansible Vault password from the keyring
[[ -z "$ANSIBLE_VAULT_KEYNAME" ]] && { echo ANSIBLE_VAULT_KEYNAME is not defined; exit 104; }
keyctl print $(keyctl request user "$ANSIBLE_VAULT_KEYNAME" @u)
