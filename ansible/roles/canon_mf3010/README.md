# Publish Canon MF-3010 printer on LAN

Canon MF3010 requires proprietary drivers that are not included in Debian
repos. This role installs those drivers and configures a shared printer via
CUPS

## Dependencies

`server` role must be applied before this one for proper firewall
configuration.
