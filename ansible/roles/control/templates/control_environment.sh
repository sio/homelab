# {{ ansible_managed }}

export ANSIBLE_VAULT_KEYNAME={{ control_ansible_vault_keyname|quote }}
export INFRA={{ control_infra_dir|quote }}
export INVENTORY={{ control_inventory|quote }}
export PLAYBOOK_ARGS=--vault-password-file="{{ control_scripts_dir }}/control-secrets-fetch.sh"
export PLAYBOOK_RUNNER=~/bin/app.venv/ansible-playbook/bin/ansible-playbook
export SSH_AUTH_SOCK={{ control_sshagent_socket|quote }}
