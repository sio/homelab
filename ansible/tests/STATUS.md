# Tests status by role

## Not implemented

- **grub**
- **initrd**
- **upgrade**
- **usbroot**


## Tested in Docker

- **deb_url**
- **interactive**
- **motd**
- **require**
- **unattended**


## Tested in Vagrant (Libvirt)

- **gerbera**: depends on server
- **morebooks**: depends on server
- **munin_fdcount**: depends on munin, server
- **munin_master**: depends on server
- **munin_node**: uses the test suite of munin_master
- **samba**: depends on server
- **server**: uses UFW, firewall can not load kernel modules in Docker
- **supysonic**: depends on server
- **torrents_sysctl**: modifies kernel parameters via sysctl, impossible in Docker
- **transmission**: depends on server, torrents_sysctl
