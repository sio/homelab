# Ansible playbooks and roles

This directory contains Ansible playbooks for my machines and roles used in
these playbooks. Role descriptions are provided in the corresponding READMEs
within role directories.

Most of the roles are continuously tested with Molecule either in Docker
containers or in Vagrant KVM boxes.

CI infrastructure is provided by:

- [GitLab CI] - for Docker tests ([configuration][gitlab-config])
- [Cirrus CI] - for KVM tests ([configuration][cirrus-config], [blog post])

[GitLab CI]: https://docs.gitlab.com/ee/ci/
[Cirrus CI]: https://cirrus-ci.org/
[gitlab-config]: ../.gitlab-ci.yml
[cirrus-config]: ../.cirrus.yml.j2
[blog post]: https://potyarkin.ml/posts/2020/cirrus-ci-integration-for-gitlab-projects/


## Usage

Makefile contains recipes for execution of Ansible playbooks. "make all"
triggers configuration management for the whole infrastructure.

All behavioral variables are defined within playbooks. Only security related
variables are meant to be provided from outside, e.g. from inventory:

- SSH authentication parameters
- Privilege elevation parameters (su/sudo)
- Paths to SSH keys that are allowed on target machine


## Secrets layout on control machine

It is more convenient to store all secrets in one place on control machine.
Sample layout:

```
~/infra/
       /Makefile.secrets
       /inventory.yml
       /ssh_client.cfg
       /keys/
            /machineA
            /machineA.pub
            /xxx
            /xxx.pub
            /...
```

All keys should be protected with a passphrase, inventory file should be
encrypted with Ansible Vault.

Local Git repository may be used for keeping track of changes.


## Test status by role

### Automated tests not implemented

- **grub**
- **initrd**
- **upgrade**
- **usbroot**

### Tested in Docker

- **canary**
- **canon_mf3010**
- **deb_url**
- **gitlab_runner**
- **interactive**
- **motd**
- **packages**
- **smarttest**
- **sshkey**
- **unattended**
- **wol**

### Tested in Vagrant (Libvirt)

- **gerbera**: depends on server
- **kvm_bridge**: modifies sysctl values, configures network interfaces, reboots
- **morebooks**: depends on server
- **munin_fdcount**: depends on munin, server
- **munin_master**: depends on server
- **munin_node**: uses the test suite of munin_master
- **munin_smart**: depends on server
- **samba**: depends on server
- **server**: uses UFW, firewall can not load kernel modules in Docker
- **supysonic**: depends on server
- **torrents_sysctl**: modifies kernel parameters via sysctl, impossible in Docker
- **transmission**: depends on server, torrents_sysctl
- **virtual_machine**: requires nested virtualization
- **virtual_usb**: udevadm does not work in Docker
- **wireguard**: modifies network interfaces


## Test status by playbook

### Tested in Vagrant (Libvirt)

- **laptopmini.yml**
- **mediabox.yml**
- **morebooks.yml** - requires no extra tests since it's just applying a role
  to the target
- **printer.yml**
- **upgrade.yml** - requires no extra tests since it's just applying a role to
  the target

## Automated tests not implemented

- **mediabox-hw** - trivial role, hardware specific
