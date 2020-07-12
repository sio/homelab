#!/bin/bash

# Shutdown the computer if canary host is offline
#
# This script is useful for dealing with dumb UPS. Computers powered by UPS can
# detect power outage by checking whether a 'canary' machine is online. Canary
# machine is meant to be powered directly from mains in the same building.
# Graceful shutdown can be attempted afterwards


# Configuration options
CANARY_HOST=${CANARY_HOST:-192.168.28.1}
CANARY_TIMEOUT=${CANARY_TIMEOUT:-90}  # seconds


# Internal variables
CANARY_SHUTDOWN=${CANARY_SHUTDOWN:-shutdown -P now CANARY_SHUTDOWN}
CANARY_CHECK=${CANARY_CHECK:-ping -c 1 -w 3 -q $CANARY_HOST}
CANARY_RETRY_DELAY=${CANARY_RETRY_DELAY:-1}  # seconds


start_time=$(date +%s)
while [[ $((start_time + CANARY_TIMEOUT)) > $(date +%s) ]]
do
    $CANARY_CHECK && exit 0
    sleep "$CANARY_RETRY_DELAY"
done
$CANARY_SHUTDOWN
