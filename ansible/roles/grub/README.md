# Manage kernel parameters in Grub defaults

The role sets kernel parameters in Grub defaults and updates Grub configuration
if neccessary.

All escaped line breaks are straightened to single line before applying values
from the list of kernel parameters.

If a kernel parameter is passed with different value than the one in config,
the old value is not removed but new one is appended to the end of kernel
command line and will override the old one upon boot.

Required kernel parameters must be defined in `grub_kernel_params` variable.

Example:

```
grub_kernel_params:
  - zswap.enabled=1
  - quiet
  - splash
```
