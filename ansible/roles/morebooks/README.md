# Set up a server with HomeLibraryCatalog instance

This role configures a clean Debian install to serve the HomeLibraryCatalog web
application.

Most of the configurable values are listed in [defaults](defaults/main.yml), you
can override them with your own. You **need to override** the personification
parameters listed at the beginning of the file to deploy a different web site.

Variables that are not defined by default:

- **deploy** -
  If set to True, forces (re)deployment of HomeLibraryCatalog from GitHub master
  branch. Use this to update HomeLibraryCatalog to the latest version.
- **restore_from** -
  Local directory with application data archives (sqlite db + file uploads).
  When setting up a new server this directory will be used to restore the latest
  backup from archive. Backups must be sortable by file name.


## TODO

- TODO: Rename variables with the same prefix (`hlc_`)
