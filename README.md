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
