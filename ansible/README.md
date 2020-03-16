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


## Test status by role

### Automated tests not implemented

- **grub**
- **initrd**
- **upgrade**
- **usbroot**

### Tested in Docker

- **deb_url**
- **interactive**
- **motd**
- **packages**
- **require**
- **unattended**

### Tested in Vagrant (Libvirt)

- **gerbera**: depends on server
- **kvm_bridge**: modifies sysctl values, configures network interfaces, reboots
- **morebooks**: depends on server
- **munin_fdcount**: depends on munin, server
- **munin_master**: depends on server
- **munin_node**: uses the test suite of munin_master
- **samba**: depends on server
- **server**: uses UFW, firewall can not load kernel modules in Docker
- **supysonic**: depends on server
- **torrents_sysctl**: modifies kernel parameters via sysctl, impossible in Docker
- **transmission**: depends on server, torrents_sysctl

### Tested on localhost (destructive!)

- **virtual_machine**: can not be tested in virtual machine because it
  launches another guest. Maybe someday, when nested virtualization will allow
  for more nesting.
