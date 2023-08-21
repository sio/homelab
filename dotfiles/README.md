# Dotfiles by Vitaly Potyarkin

All dotfiles are organized into topic directories.

By default dotfiles are targeting "$HOME" and recreate the directory structure
of the topic directory below. Some topics target other directories (system-wide
configuration), that information is defined in `$topicname/dotfiles.meta`

[This blog post](https://potyarkin.com/posts/2019/on-dotfiles-management/)
provides an overview of dotfile management approach used here.
See [bootstrap.sh](./bootstrap.sh) for more information.


## TODO

- Move all root actions to Ansible playbooks/roles (`SCOPE=system`)

### Topics that are not bootstrappable at the moment

- *None listed at the moment*

### Topics that are not yet added to the dotfiles repo

- *None listed at the moment*

### Extra functionality for bootstrap.sh

- **Config templates** - add another supported action for `bootstrap.sh` that
  would generate the configuration file from a template. This has not been done
  yet because I am not aware of any simple templating engine for bash, and other
  options (like Jinja2) would make the script less portable
