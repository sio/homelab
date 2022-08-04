# Definitive role for ssh key management

Only ssh keys defined via this role will be present on target machine

See `defaults/main.yml` for examples.


## Important

This role assumes a dependency on `server` role. If `server` role was not
applied previously, the role will only work on Debian Bullseye and newer


## Known limitations

This role does not support custom key options [TODO], because
custom key_options are not compatible with `exclusive: yes` in Ansible
"authorized_key" module
