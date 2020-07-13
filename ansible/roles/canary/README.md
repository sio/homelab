# Graceful shutdown on power outage even with dumb UPS

This role installs a systemd unit which regularly checks that canary host is
online. Canary host should be a device powered by the same electricity source
but without UPS, e.g. a router. When canary device goes down (in case of power
outage) graceful shutdown is initiated.
