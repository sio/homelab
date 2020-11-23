# Reusable playbooks for importing

Playbooks that are not very useful on their own but are meant to be imported
into other playbooks.

These playbooks are not really fit to become roles, because they are usually
stateful and not idempotent. Typical usecase is:

```yaml
- import_playbook: plays/something-prepare.yml

# do stuff

- import_playbook: plays/something-cleanup.yml
```
