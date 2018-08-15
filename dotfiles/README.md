# Dotfiles by Vitaly Potyarkin

All dotfiles are organized into topic directories.

By default dotfiles are targeting "$HOME" and recreate the directory structure
of the topic directory below. Some topics target other directories (system-wide
configuration), that information is defined in `$topicname/dotfiles.meta`

See [bootstrap.sh](./bootstrap.sh) for more information.


## TODO

### Topics that are not bootstrappable at the moment

- **cron-user** - look into installing cron actions into directories, not with
  crontab
- **ssh-client** - the config file is not really generic, needs more thinking

### Topics that are not yet added to the dotfiles repo

- *None listed at the moment*
