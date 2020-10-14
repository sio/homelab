# {{ ansible_managed }}

export ANSIBLE_VAULT_KEYNAME={{ control_keyring_id_vault_password|quote }}
export INFRA={{ control_infra_dir|quote }}
export INVENTORY={{ control_inventory|quote }}
export PLAYBOOK_ARGS='--vault-password-file "{{ control_scripts_dir }}/control-secrets-fetch.sh"'
