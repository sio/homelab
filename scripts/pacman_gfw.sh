#!/bin/bash
#
# Restore Pacman in portable Git for Windows setup
# (thanks to https://stackoverflow.com/a/65204171)


# Strict mode
set -euo pipefail

# Verbose execution
set -v

# Exit early if pacman is installed
pacman --version && exit

# Initialize temporary directory
TEMPDIR="$(mktemp -d)"

# Download pacman
COMMIT=7858ee9c236402adf569ac7cff6beb1f883ab67c
declare -A COMPONENTS=( # old versions are referenced intentionally to avoid zstd requirement
    ["pacman-5.2.2-4-x86_64"]="usr"
    ["pacman-mirrors-20201028-1-any"]="etc"
    ["msys2-keyring-1~20201002-1-any"]="usr"
)
curl -L "https://github.com/msys2/MSYS2-packages/raw/$COMMIT/pacman/pacman.conf" -o /etc/pacman.conf
cd /
for package in ${!COMPONENTS[@]}
do
    curl "https://repo.msys2.org/msys/x86_64/$package.pkg.tar.xz" -o "$TEMPDIR/$package.pkg.tar.xz"
    tar xJvf "$TEMPDIR/$package.pkg.tar.xz" "${COMPONENTS[$package]}"
done

# Initialize pacman
mkdir -p /var/lib/pacman
pacman-key --init
pacman-key --populate msys2
pacman --sync --refresh --sysupgrade

# Clean up temporary directory
[ -n "$TEMPDIR" ] && rm -rf "$TEMPDIR"

# Restore package database
URL=https://github.com/git-for-windows/git-sdk-64/raw/main
cat /etc/package-versions.txt | while read package version
do
    destination=/var/lib/pacman/local/$package-$version
    mkdir -pv $destination
    for file in desc files install mtree
    do
        curl -sSL "$URL$destination/$file" -o $destination/$file
    done
done

# Upgrade to current version of pacman
pacman -S --overwrite '*' pacman pacman-mirrors msys2-keyring
