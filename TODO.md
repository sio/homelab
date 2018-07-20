# Ideas

- Add a setup script that places all the symlinks in their places,
  support multiple targets: common, desktop, server, etc.
    - Look at https://github.com/holman/dotfiles - symlink target gets
      autodetected based on the filename/dirname. I do not particularly agree
      with his implementation, but the idea is good.
        - How to handle duplicates? If two files point at the same target -
          which one will be linked
        - `script/bootstrap` is nice, but it's a technical debt to manage.
          Maybe use ansible instead? That takes care of linking two files
          (lineinfile)

- How do I copy from tmux to system clipboard when mouse mode is enabled?
