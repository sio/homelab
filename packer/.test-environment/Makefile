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
		packer \
		python3-yaml \
		cpu-checker \
		qemu-kvm \
		libvirt-clients \
		libvirt-daemon-system
	touch $@


/.ready-interactive:
	cd ../../dotfiles && ./bootstrap.sh ./topics-cli.list
	touch $@
