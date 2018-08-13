#!/usr/bin/env bash

# Setup script for the dotfiles
#
# Dotfiles are to be organized by topic.
# Files with *.copy filenames will be copied into home directory,
# files with *.link filenames will be linked to from home directory.
# All other files and directories are ignored.
#
# Example:
#    topic-foo/vimrc.link:
#       Will be symlinked from ~/.vimrc
#    topic-bar/bashrc.copy
#       Will be copied over to ~/.bashrc
#
# Topic names are irrelevant to the script, they are supported for user's
# convenience only.
