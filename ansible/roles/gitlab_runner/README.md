# Configure GitLab runner

Uses shell executor by default.

Applying multiple roles to a single host is not supported:

- Handlers that rely on role variable values are not flushed automatically
- Systemd unit name is not configurable
- Other possible failure points have not been sanitized
