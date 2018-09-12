# Package lists

This directory contains package lists for packages I usually install in a fresh
Linux system.

Naming convention is `$distro.$target`, e.g. `debian.desktop` is for a desktop
setup with Debian Linux.

Package lists contain one package name per line with no syntax support for
comments. That makes installing listed packages as easy as
`aptitude install $(cat debian.desktop)`
