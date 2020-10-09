#!/bin/sh
# Read from stdin, print to stdout, ignore all commandline arguments

# Set SSH_ASKPASS=/path/to/this/script; DISPLAY=some-dummy-value
# to allow passing identity passphrase to ssh-add non-interactively:
#   echo $PASSPHRASE|ssh-add ...
cat
