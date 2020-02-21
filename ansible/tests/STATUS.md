# Tests status by role

## Not implemented

- **grub**
- **initrd**
- **kodi**: depends on server
- **munin**: depends on server
- **munin_fdcount**: depends on munin, server
- **munin_node**
- **supysonic**: depends on server
- **upgrade**
- **usbroot**


## Tested in Docker

- **deb_url**
- **interactive**
- **motd**
- **require**


## Tested in Vagrant (Libvirt)

- **morebooks**: depends on server
- **samba**: depends on server
- **server**: uses UFW, firewall can not load kernel modules in Docker
- **torrents_sysctl**: modifies kernel parameters via sysctl, impossible in Docker
- **transmission**: depends on server, torrents_sysctl
