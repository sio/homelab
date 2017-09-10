# Common configuration files for my remote servers
These files are meant to be placed in ~/common.git directory on the
remote server. Post-receive hook unpacks the files into ~/common.
When I will manage more than one server I'll consider hosting this
repo elsewhere.

Creating symbolic links from appropriate places enables all or
part of shared configuration.


## Directory structure
### cli-tools/
Configuration files for command line tools (bash, vim, etc)

### cron/
Simple repeated tasks to be scheduled with cron

### git/
Hook samples and other reusable files

### morebooks/
Application behind morebooks.ml


## Licence and copyright
Copyright 2017 Vitaly Potyarkin

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


## Contributing
This project is intended for personal use, and I doubt it would attract any
contributors. If you have anything to add or suggest, please contact me.
I can't guarantee I'll accept your proposal, but I promise to behave
responsibly and treat all contributors with respect.
