include ../Makefile.packer


DRIVERS_VERSION=0.1.171-1
DRIVERS_URL=https://fedorapeople.org/groups/virt/virtio-win/repo/stable/virtio-win-$(DRIVERS_VERSION).noarch.rpm
DRIVERS_STORAGE?=drivers
PACKER_ARTIFACTS+=$(DRIVERS_STORAGE)
PACKER_FLAGS+=-var drivers="$(DRIVERS_STORAGE)"


export VM_PASSWORD
PACKER_FLAGS+=-var password="$$VM_PASSWORD" -var hostname="$(VM_HOSTNAME)"
PACKER_FLAGS+=-var iso="$(VM_ISO)"


ifdef VM_ISO_SHA256
PACKER_FLAGS+=-var iso_sha256="$(VM_ISO_SHA256)"
else
PACKER_FLAGS+=-var iso_checksum_type=none
endif


ifdef REMOTE_VNC
PACKER_FLAGS+=-var vnc_bind_address=0.0.0.0
endif


validate build: | check-env
validate build: | drivers


.PHONY: drivers
drivers: $(DRIVERS_STORAGE)/netkvm.sys


$(DRIVERS_STORAGE)/netkvm.sys: | $(DRIVERS_STORAGE)/temp/extracted.ok
	find $(DRIVERS_STORAGE)/temp/iso \
		-type f \
		-path '*/w10/amd64/*' \
		! -iname '*.pdb' \
		-exec cp {} $(DRIVERS_STORAGE)/ \;
	-$(RM) -r $(DRIVERS_STORAGE)/temp
	-$(RM) $(DRIVERS_STORAGE)/virtio-win.rpm


.INTERMEDIATE: $(DRIVERS_STORAGE)/temp/extracted.ok
$(DRIVERS_STORAGE)/temp/extracted.ok: $(DRIVERS_STORAGE)/virtio-win.rpm
	-mkdir -p $(dir $@)/rpm $(dir $@)/iso
	cd $(dir $@)/rpm && cmake -E tar xf ../../$(notdir $<)  # cmake uses libarchive to extract
	cd $(dir $@)/iso && cmake -E tar xf ../rpm/usr/share/virtio-win/virtio-win.iso
	touch $@


.INTERMEDIATE: $(DRIVERS_STORAGE)/virtio-win.rpm
$(DRIVERS_STORAGE)/virtio-win.rpm:
	-mkdir -p $(DRIVERS_STORAGE)
	curl -o $@ -L "$(DRIVERS_URL)"


.PHONY: check-env
check-env:
ifndef VM_ISO
	$(error Required variable not defined: VM_ISO)
endif
ifndef VM_HOSTNAME
	$(error Required variable not defined: VM_HOSTNAME)
endif
ifndef VM_PASSWORD
	$(error Required variable not defined: VM_PASSWORD)
endif
