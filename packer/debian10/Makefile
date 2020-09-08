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


# Default values for remote build
remote-build: export VM_HOSTNAME?=guest
remote-build: export VM_PASSWORD?=hello


baremetal.patch:
	diff preseed.cfg baremetal.cfg > $@


baremetal.cfg: baremetal.patch preseed.cfg
	patch preseed.cfg baremetal.patch -o $@
