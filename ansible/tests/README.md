# Automated tests for Ansible playbooks

Some playbooks in this repo contain automated tests implemented using
Molecule.

Use Makefile provided in this directory to launch tests.

For example:

```shell
$ make
..Execute automated tests for all roles..

$ make test ANSIBLE_ROLE=../roles/motd
..Execute tests for a single role at provided path..

$ make login ANSIBLE_ROLE=../roles/motd
..Provision Docker container, apply the role and start interactive shell..
```

Refer to `make help` and read the Makefile for more information.
