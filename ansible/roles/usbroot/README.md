# Optimizations for running Debian from USB flash drive

Placing root filesystem on USB is sensible for home appliances: they do not
get much i/o regarding program files and do not require high performance.

Important topics for running from USB flash:

- Disable ext4 journaling **(not handled by this role)**
- Use `noatime` mount flag **(not handled by this role)**
- Disable swap
- Save systemd journal to RAM
- Mount /tmp, /var/tmp, /var/log to RAM

Layout:

- `/`: USB drive
- `/storage/`: HDD
- `/home`: **???** - Maybe bind from `/storage/users`
