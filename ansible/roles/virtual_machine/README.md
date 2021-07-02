# Setup guest virtual machines with libvirt/kvm

## Cloud-init

This role supports cloud-init deployment with local datasource (`NoCloud`).
ISO image for instance data is generated automatically based on provided
Jinja2 templates.

Cloud-init (Openstack) images are available for all major Linux distributions:
<https://docs.openstack.org/image-guide/obtain-images.html>


## Kernel Samepage Merging (KSM)

KSM is enabled automatically when using this role.

ksmtuned is installed to control the behavior: KSM is disabled if there is
enough free memory and is made to work harder and harder when memory load
increases. The whole daemon is a [simple bash script][ksmtuned], check source
code to understand its behavior.

[ksmtuned]: https://github.com/bzed/debian-ksmtuned/blob/master/ksmtuned
