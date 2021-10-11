include ../Makefile.packer


ifdef VM_PASSWORD
export VM_PASSWORD
endif
PACKER_FLAGS=-var root_password="$$VM_PASSWORD" -var hostname="$(VM_HOSTNAME)"


validate build: | check-env


.PHONY: check-env
check-env:
ifndef VM_HOSTNAME
	$(error Required variable not defined: VM_HOSTNAME)
endif
ifndef VM_PASSWORD
	$(error Required variable not defined: VM_PASSWORD)
endif


# Custom images for Debian releases
debian10: build
debian10: export ISO_URL=https://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/debian-10.11.0-amd64-netinst.iso
debian10: export ISO_CHECKSUM_URL=https://cdimage.debian.org/cdimage/archive/latest-oldstable/amd64/iso-cd/SHA512SUMS
debian10: PACKER_FLAGS+=-var iso_url="$$ISO_URL" -var iso_checksum_url="$$ISO_CHECKSUM_URL"

debian11: build
debian11: export ISO_URL=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.1.0-amd64-netinst.iso
debian11: export ISO_CHECKSUM_URL=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA512SUMS
debian11: PACKER_FLAGS+=-var iso_url="$$ISO_URL" -var iso_checksum_url="$$ISO_CHECKSUM_URL"

debian-testing: build
debian-testing: export ISO_URL=https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/debian-testing-amd64-netinst.iso
debian-testing: export ISO_CHECKSUM_URL=https://cdimage.debian.org/cdimage/weekly-builds/amd64/iso-cd/SHA512SUMS
debian-testing: PACKER_FLAGS+=-var iso_url="$$ISO_URL" -var iso_checksum_url="$$ISO_CHECKSUM_URL"


# Default values for remote build
remote-build: export VM_HOSTNAME?=guest
remote-build: export VM_PASSWORD?=hello


PATCHES=baremetal.patch
ifeq (yes,$(EFI))
PATCHES+=baremetal-efi.patch
endif

baremetal.patch baremetal-efi.patch:
	diff -Naur preseed.cfg $(patsubst %.patch,%.cfg,$@) > $@

baremetal.cfg: preseed.cfg $(PATCHES)
	cp preseed.cfg $@
	cat $(filter %.patch,$^) | patch
