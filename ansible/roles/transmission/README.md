# Install Transmission torrent client

Install transmission and configure it to efficiently seed lots of torrents


## IMPORTANT

Transmission 2.92 in Debian is known to leak memory with SSL announce URLs.
The workaround is included in Transmission 2.94 (Debian Buster), compiling
2.92/2.94 on Stretch with custom configuration is also possible.

- <https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=865624>
- <https://github.com/transmission/transmission/issues/313>
