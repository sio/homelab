# Wait for specified systemd services to reach desired state

This can be useful to ensure that multiple oneshot services are never running
more than one at the same time. Helpful for backups.

**WARNING**: Beware of circular dependencies, they may create a deadlock.
             See `molecule/default/converge.yml` for a workaround.
