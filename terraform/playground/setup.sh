#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

OPT=/opt
BIN=/usr/local/bin

install_go() {
    local GO_VERSION="$1"
    local GO_URL="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
    local WORKDIR=$(mktemp --tmpdir --directory golang.XXXXXXX)
    mkdir -p "${WORKDIR}" "${OPT}" "${BIN}"
    pushd "${WORKDIR}"

    wget "${GO_URL}" -O archive
    rm -rf "${OPT}/go"
    tar -C "${OPT}" -axvf archive
    ln -sf "${OPT}/go/bin/go" "${BIN}/go"

    popd
    [[ -d "${WORKDIR}" ]] && rm -rf "${WORKDIR}"
}

install_watchexec() {
    local WATCHEXEC_VERSION="$1"
    local WATCHEXEC_URL=https://github.com/watchexec/watchexec/releases/download/cli-v${WATCHEXEC_VERSION}/watchexec-${WATCHEXEC_VERSION}-x86_64-unknown-linux-gnu.tar.xz
    local WORKDIR=$(mktemp --tmpdir --directory watchexec.XXXXXXX)
    mkdir -p "${WORKDIR}" "${OPT}" "${BIN}"
    pushd "${WORKDIR}"

    wget "${WATCHEXEC_URL}" -O archive
    rm -rf "${OPT}/watchexec"
    tar -axvf archive
    mv watchexec* "${OPT}/watchexec"
    ln -sf "${OPT}/watchexec/watchexec" "${BIN}/watchexec"

    popd
    [[ -d "${WORKDIR}" ]] && rm -rf "${WORKDIR}"
}

apt-get update
apt-get install -y --no-install-recommends \
    gcc \
    gdb \
    libc-dev \
    procps \
    psmisc \
    xterm \

install_go 1.20.3
install_watchexec 1.20.5
