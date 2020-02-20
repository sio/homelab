# Tests status by role

## Not implemented

- **grub**
- **initrd**
- **kodi**: depends on server
- **munin_fdcount**: depends on munin, server
- **munin_node**
- **upgrade**
- **usbroot**


## Tested in Docker

- **deb_url**
- **interactive**
- **motd**
- **require**
- **unattended**


## Tested in Vagrant (Libvirt)

- **morebooks**: depends on server
- **munin_master**: depends on server
- **samba**: depends on server
- **server**: uses UFW, firewall can not load kernel modules in Docker
- **supysonic**: depends on server
- **torrents_sysctl**: modifies kernel parameters via sysctl, impossible in Docker
- **transmission**: depends on server, torrents_sysctl
