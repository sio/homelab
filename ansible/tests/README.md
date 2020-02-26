# Automated tests for Ansible playbooks

Most playbooks in this repo contain automated tests implemented using
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

---
---
---

# Some notes on tests implementation

## Systemd in Docker

```yaml
platforms:
  - name: debian10-docker
    image: potyarkin/molecule:debian-10-systemd
    pre_build_image: true
    command: /sbin/init
    capabilities:
      - SYS_ADMIN
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
      - /lib/modules:/lib/modules:ro
    tmpfs:
      - /run
      - /tmp
```

## Ansible verifier for Molecule

See `roles/transmission` for example.

Useful modules:

- assert
- command
- fail
- package_facts
- ping
- service_facts
- wait_for

Useful techniques:

- Early exit: failed_when

Links:

- [Molecule Issue #2013: Make Ansible default verifier](https://github.com/ansible-community/molecule/issues/2013)
- [Assertion examples](https://github.com/ansible/ansible/blob/faa9533734a1ee3f0bb563704b277ffcc3a2423f/test/integration/targets/stat/tasks/main.yml#L29)
- [Command module](https://github.com/Caseraw/ansible_role_chrony/blob/620bcad8789f7638cde27e43167d98100ff74792/molecule/default/verify.yml)
- [More command module](https://github.com/alvistack/ansible-role-cri_tools/blob/fb52fe1c6c10e05d9992e960d6ab65ab6b7d1c6c/molecule/redhat-7/verify.yml)
- [Ping module](https://github.com/robertdebock/ansible-role-natrouter/blob/a12bd323dd0a86cedbb1d034b4574b20a8f5b73e/molecule/default/verify.yml)
