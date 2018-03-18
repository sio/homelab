# My ansible playbooks and roles

## Ideas


### Manage APT sources list
### Get Let's Encrypt certificate

### Manage kernel options in /etc/default/grub
Too difficult to do with regex (considering escaped newlines, existing
parameters with different value, etc).

Maybe it's better to do manually for now, or use templates.

Another option is to assume no line breaks occur. Also, there is Grubby, which
is not in Debian repos.


## Implemented
### initrd - Manage initramfs modules
This role accepts a list of modules as a variable and makes sure all of them
are in initramfs. No reboot is performed, though.

### upgrade - Apply all package updates
No reboot is performed, but a check and a handler may be added later.

Currently only supports apt-based systems, but will do no harm on other
distributions.
