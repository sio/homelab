# Set up a server with HomeLibraryCatalog instance

This role configures a clean Debian install to serve the HomeLibraryCatalog web
application.

Most of the configurable values are listed in [defaults](defaults/main.yml), you
can override them with your own.

Variables that are not defined by default:

- **deploy** - if set to True, forces the deployment of HomeLibraryCatalog from
  GitHub master branch. Use this to update HomeLibraryCatalog to the latest
  version.
- **admin_unprivileged** - Unprivileged account name used to access the server
  via SSH. Defaults to the inventory value of `ansible_user` at the time of
  invocation.
