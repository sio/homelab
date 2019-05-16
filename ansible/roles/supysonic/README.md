# Install Supysonic music server

## IMPORTANT

This role will not work correctly with Ansible 2.2 because of the bug in
lookup plugin: https://github.com/ansible/ansible/issues/22359


## Role variables

Required:

- **supysonic_music_dir** - full path to the music directory on the remote
  machine
- **supysonic_url** - domain name for accessing Supysonic (without *http://* or
  *www*)

Optional:

- **supysonic_update** - if set, Supysonic will be updated to the latest git
  version
- **supysonic_user** - OS account for running Supysonic processes
