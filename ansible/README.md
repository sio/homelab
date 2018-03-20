# My ansible playbooks and roles

## Ideas

- Copy and setup $COMMON git repo
- Manage APT sources list
- Get Let's Encrypt certificate

## Implemented roles
### initrd - Manage initramfs modules
The role accepts a list of modules as a variable and makes sure all of them
are in initramfs. No reboot is performed, though.

### grub - Manage kernel parameters in Grub defaults
The role sets kernel parameters in Grub defaults and updates Grub configuration
if neccessary.

All escaped line breaks are straightened to single line before applying values
from the list of kernel parameters.

If a kernel parameter is passed with different value than the one in config,
the old value is not removed but new one is appended to the end of kernel
command line and will override the old one upon boot.

### upgrade - Apply all package updates
No reboot is performed, but a check and a handler may be added later.

Currently only supports apt-based systems, but will do no harm on other
distributions.
