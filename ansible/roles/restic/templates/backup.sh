#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

#
# Create new backup and prune old ones according to retention policy
#
# {{ ansible_managed }}
#

set -x
RESTIC=${RESTIC:-restic}

$RESTIC snapshots || $RESTIC init

$RESTIC backup \
    --files-from {{ restic_backup_list|quote }} \
{% for tag in restic_backup_tags %}
    --tag {{ tag }} \
{% endfor %}

$RESTIC forget \
{% if restic_backup_tags %}
    --tag {{ restic_backup_tags|join(',') }} \
{% endif %}
{% for key, value in restic_backup_retention.items() %}
    --{{ key|replace("_", "-") }} {{ value }} \
{% endfor %}

$RESTIC prune
$RESTIC check
$RESTIC snapshots
