#!/bin/bash
#
# {{ ansible_managed }}
#
# Unregister all GitLab runners previously configured
#
set -euo pipefail
IFS=$'\n\t'


export CONFIG_FILE={{ gitlab_runner_config|quote }}

gitlab-runner unregister --all-runners
