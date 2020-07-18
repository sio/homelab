# Common configuration files for my Unix-like machines

Configuration files (dotfiles) and other common files shared between
my local and remote machines (mostly server-side stuff)

These files are meant to be placed into "$HOME/.common" directory on all of
my Unix-like machines. Some kind of schedule has to be set up on each machine
to fetch changes from origin repository on a regular basis.

Creating symbolic links from appropriate places enables all or
part of shared configuration. See [bootstrap.sh](dotfiles/bootstrap.sh) for more
information

Typical initialization:

```sh
$ git clone --recursive "https://gitlab.com/sio/server_common.git" ~/.common
...
$ ~/.common/dotfiles/bootstrap.sh ~/.common/dotfiles/topics-cli.list
...
$ exec bash  # restart shell with new settings
```


## Directory structure

### ansible/

Playbooks and roles for automating remote computer maintenance

### dotfiles/

Configuration files for command line and graphic tools, easily installed with a
bootstrap script.

### packer/

Virtual machine templates

### snippets/

Git hooks samples and other reusable files

### submodules/

Code from other repos that is required by this one


## License and copyright

Copyright 2017-2019 Vitaly Potyarkin

```
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```


## Contributing

This project is intended for personal use, and I doubt it would attract any
contributors. If you have anything to add or suggest, please contact me.
I can't guarantee I'll accept your proposal, but I promise to behave
responsibly and treat all contributors with respect.
