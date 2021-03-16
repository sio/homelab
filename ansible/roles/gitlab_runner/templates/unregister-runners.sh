#!/bin/sh
#
# {{ ansible_managed }}
#
# Unregister all GitLab runners previously configured
#


export CONFIG_FILE={{ gitlab_runner_config|quote }}

gitlab-runner unregister --all-runners
