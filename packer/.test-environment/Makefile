# Prepare a test environment for Packer builds on a clean Debian server
#
# This is meant to be used on THROWAWAY SYSTEMS ONLY,
# some configuration may not be easily reversible


.PHONY: prepare
prepare: /.ready-for-packer
prepare: /.ready-interactive


/.ready-for-packer:
	apt-get update
	apt-get -y install --no-install-recommends \
		aria2 \
		packer \
		python3-yaml \
		cmake \
		cpu-checker \
		qemu-kvm \
		qemu-utils \
		libguestfs-tools \
		libvirt-clients \
		libvirt-daemon-system
	touch $@


/.ready-interactive:
	apt-get -y install --no-install-recommends \
		tmux \
		vim
	cd ../../dotfiles && ./bootstrap.sh ./topics-cli.list
	touch $@
