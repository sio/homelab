include ../Makefile.packer


DRIVERS_VERSION=0.1.171-1
DRIVERS_URL=https://fedorapeople.org/groups/virt/virtio-win/repo/stable/virtio-win-$(DRIVERS_VERSION).noarch.rpm
DRIVERS_STORAGE?=drivers
PACKER_ARTIFACTS+=$(DRIVERS_STORAGE)
PACKER_FLAGS+=-var drivers="$(DRIVERS_STORAGE)"


ifdef VM_PASSWORD  # do not export empty value
export VM_PASSWORD
endif
PACKER_FLAGS+=-var password="$$VM_PASSWORD" -var hostname="$(VM_HOSTNAME)"


ifdef VM_ISO
export VM_ISO
endif
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


include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2020.08.04/Makefile.venv"
	echo "4b99544cd89019a802de25637a6bbd137368946afe291aff18e734b0c47c2ed7 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv


.PHONY: remote-build
remote-build: export CI_COMMIT_SHA=$(shell git rev-parse HEAD)
remote-build: export CI_REPOSITORY_URL=https://gitlab.com/sio/server_common.git
remote-build: export PACKER_TARGET=windows10
remote-build: export VM_HOSTNAME?=windowsvm
remote-build: export VM_PASSWORD?=windowspassword
remote-build: | $(VENV)/cirrus-run
	$(VENV)/cirrus-run ../cirrus.yml.j2
