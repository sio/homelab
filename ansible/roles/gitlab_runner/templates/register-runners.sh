#!/bin/sh
#
# {{ ansible_managed }}
#
# Register GitLab runners configured for this host
#


export CONFIG_FILE={{ gitlab_runner_config|quote }}

gitlab-runner unregister --all-runners

gitlab-runner register \
    --non-interactive \
    --url {{ gitlab_runner_ci_host|quote }} \
    --registration-token {{ gitlab_runner_token|quote }} \
    --executor {{ gitlab_runner_executor|quote }} \
    {% for key, value in gitlab_runner_extra_registration_params.items() %}
    --{{ key }} {{ value|quote if value else '' }} \
    {% endfor -%}
    {%- if gitlab_runner_tags: -%}
    --tag-list "{{ gitlab_runner_tags|join(",") }}"
    {%- endif %}
