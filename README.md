# Configuration as Code for Vitaly Potyarkin's infrastructure

This repository contains common configuration files (dotfiles) and
configuration management code (ansible, packer) for my personal
infrastructure.

All changes are applied automatically via continuous delivery [pipelines]
(GitLab SaaS). These pipelines are also executed on schedule to enforce
consistent state across all machines and to combat configuration drift.

Since this is a personal project and all machines are more or less unique
(pets), provisioning new instances is not automated. Typically it involves
installing operating system on bare metal (preseed, autounattend) or in
virtual machine (packer, cloudinit) and adding new hosts to Ansible inventory to be
picked up by the next CD invocation.

[pipelines]: https://gitlab.com/sio/server_common/pipelines?ref=deploy


## Directory structure

### ansible/

Playbooks and roles for automating remote computer maintenance

### cloudinit/

Cloud-init templates for frequently used virtual machines

### dotfiles/

Configuration files for command line and graphic tools, easily installed with a
bootstrap script.

Typical initialization:

  - For persistent machines use Ansible role:
    [roles/interactive](ansible/roles/interactive/)
  - For playground machines:
    ```sh
    apt update; apt -y install git vim make tmux bc ncurses-term  # git and some tools

    git clone --recursive "https://gitlab.com/sio/server_common.git" ~/.common

    make -C ~/.common/dotfiles cli
    make -C ~/.common/dotfiles bash-no-tmout  # only relevant for playground machines

    exec bash  # restart shell with new settings
    ```

### packer/

Virtual machine templates

### snippets/

Git hooks samples and other reusable files

### submodules/

Code from other repos that is required by this one


## License and copyright

Copyright 2017-2022 Vitaly Potyarkin

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

If you want to discuss the technology I use, to ask a question or even just to
chat - do not hesitate to open an [issue] in this repo. I always enjoy a
friendly conversation and there is never enough techy folks around me.

[issue]: https://gitlab.com/sio/server_common/-/issues
