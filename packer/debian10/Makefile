include ../Makefile.packer


ifndef VM_HOSTNAME
	$(error Required variable not defined: VM_HOSTNAME)
endif


ifndef VM_PASSWORD
	$(error Required variable not defined: VM_PASSWORD)
endif
export VM_PASSWORD


PACKER_FLAGS=-var root_password="$$VM_PASSWORD" -var hostname="$(VM_HOSTNAME)"
