#!/bin/bash

# Clear saved identities from ssh-agent
ssh-add -D

# Clear remembered password from keyring
keyctl unlink $(keyctl list @u|grep 'key inaccessible (Permission denied)'|cut -d\: -f1) @u
