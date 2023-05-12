#!/bin/bash
#
# {{ ansible_managed }}
#
# Register GitLab runners configured for this host
#
set -euo pipefail
IFS=$'\n\t'


export CONFIG_FILE={{ gitlab_runner_config|quote }}

gitlab-runner unregister --all-runners || true

gitlab-runner register \
    --non-interactive \
    --url {{ gitlab_runner_ci_host|quote }} \
    --registration-token {{ gitlab_runner_token|quote }} \
    --executor {{ gitlab_runner_executor|quote }} \
    {% for key, value in gitlab_runner_extra_registration_params.items() -%}
    {% if value is string -%}
    --{{ key }}{{ "=" + value|quote if value else '' }} \
    {% else -%}
    {% for subvalue in value -%}
    --{{ key }}{{ "=" + subvalue|quote if subvalue else '' }} \
    {% endfor -%}
    {% endif -%}
    {% endfor -%}
    {% if gitlab_runner_tags: -%}
    --tag-list "{{ gitlab_runner_tags|join(",") }}"
    {% endif -%}

