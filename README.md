# Common configuration files for my remote servers
These files are meant to be placed in ~/common.git directory on the
remote server. Post-receive hook unpacks the files into ~/common.
When I will manage more than one server I'll consider hosting this
repo elsewhere.

After that make symbolic links to them from the appropriate places.


## Directory structure
### git/
Hook samples and other reusable files.

### cli-tools/
Configuration files for command line tools (bash, vim, etc).
