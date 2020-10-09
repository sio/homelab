# Custom control node for my infrastructure

This role is only useful with my particular way of managing infrastructure.

It sets up a control node from which all Ansible playbooks will be executed.
SSH keys are loaded into ssh-agent on boot. Passpharases for SSH keys and
password to Ansible Vault are asked on boot and are stored in RAM until
poweroff.

No automatic triggers for playbooks are added at this moment. Any playbook may
be executed by calling `make $PLAYBOOK_NAME` from `~/.common/ansible` for node
operator.
