# TODO list for Ansible playbooks

- Automated testing with Molecule
- Mediabox
    - Write roles
        - dlna
    - Test playbooks in virtual machine
        - server
        - deb_url + transmission
        - munin_node + munin_*
        - samba
        - supysonic
        - supysonic + munin
        - interactive
        - dlna
    - Write full playbook for mediabox
    - Test full playbook in VM
    - Check firewall configuration for mediabox VM
    - Apply mediabox playbook to bare metal box
- Backup
    - Configure borgbackup with several storage backends
        - See borgmatic for declarative configuration
    - Find offsite solution for storing backups (3-2-1 strategy)