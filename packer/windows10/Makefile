include ../Makefile.packer


DRIVERS_VERSION?=0.1.185-2
DRIVERS_URL?=https://fedorapeople.org/groups/virt/virtio-win/repo/stable/virtio-win-$(DRIVERS_VERSION).noarch.rpm
ifeq (latest,$(DRIVERS_VERSION))
DRIVERS_URL=https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.noarch.rpm
endif
ifeq (stable,$(DRIVERS_VERSION))
DRIVERS_URL=https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.noarch.rpm
endif
DRIVERS_STORAGE?=drivers
DRIVERS_IMAGE=$(DRIVERS_STORAGE).img
DRIVERS_IMAGE_TYPE?=harddisk
DRIVERS_MOUNTPOINT=$(DRIVERS_STORAGE)_mnt


PACKER_ARTIFACTS+=$(DRIVERS_STORAGE) $(DRIVERS_IMAGE) $(DRIVERS_MOUNTPOINT)
PACKER_FLAGS+=-var drivers="$(DRIVERS_STORAGE)"


ifdef VM_PASSWORD  # do not export empty value
export VM_PASSWORD
endif
PACKER_FLAGS+=-var password="$$VM_PASSWORD" -var hostname="$(VM_HOSTNAME)"


ifdef VM_ISO
export VM_ISO
endif
PACKER_FLAGS+=-var iso="$$VM_ISO"


ifdef VM_ISO_SHA256
PACKER_FLAGS+=-var iso_sha256="$(VM_ISO_SHA256)"
else
PACKER_FLAGS+=-var iso_sha256=none
endif


ifdef REMOTE_VNC
PACKER_FLAGS+=-var vnc_bind_address=0.0.0.0
endif


validate build: | check-env
validate build: | drivers


.PHONY: drivers
drivers: $(DRIVERS_IMAGE)


ifeq (floppy,$(DRIVERS_IMAGE_TYPE))
$(DRIVERS_IMAGE): PATH:=/sbin:$(PATH)
$(DRIVERS_IMAGE): $(DRIVERS_STORAGE)/netkvm.sys
	# virt-make-fs can not create floppies larger than 1.44MB
	dd if=/dev/zero of=$@ bs=1M count=3
	mkfs.vfat -F 12 -M 0xF0 -n DRIVERS -I -v $@
	mkdir -p $(DRIVERS_MOUNTPOINT)
	guestmount -a $@ -m /dev/sda $(DRIVERS_MOUNTPOINT)  # libguestfs-tools
	cp -R $(DRIVERS_STORAGE)/* $(DRIVERS_MOUNTPOINT)
	guestunmount $(DRIVERS_MOUNTPOINT)
	rmdir $(DRIVERS_MOUNTPOINT)
endif
ifeq (harddisk,$(DRIVERS_IMAGE_TYPE))
$(DRIVERS_IMAGE): $(DRIVERS_STORAGE)/netkvm.sys
	virt-make-fs --partition --format=raw --type=fat -- $(DRIVERS_STORAGE) $@
endif


$(DRIVERS_STORAGE)/netkvm.sys: | $(DRIVERS_STORAGE)/temp/extracted.ok
	find $(DRIVERS_STORAGE)/temp/iso \
		-type f \
		-path '*/w10/amd64/*' \
		! -iname '*.pdb' \
		-exec cp {} $(DRIVERS_STORAGE)/ \;
	-$(RM) -r $(DRIVERS_STORAGE)/temp
	-$(RM) $(DRIVERS_STORAGE)/virtio-win.rpm


.INTERMEDIATE: $(DRIVERS_STORAGE)/temp/extracted.ok
USER?=$(shell whoami)
$(DRIVERS_STORAGE)/temp/extracted.ok: $(DRIVERS_STORAGE)/virtio-win.rpm
	-mkdir -p $(dir $@)/rpm $(dir $@)/iso
	cd $(dir $@)/rpm && cmake -E tar xf ../../$(notdir $<)  # cmake uses libarchive to extract
	cd $(dir $@)/iso && cmake -E tar xf ../rpm/usr/share/virtio-win/virtio-win.iso
	chown $(USER) -R $(dir $@)
	chmod u+w -R $(dir $@)
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


# Default values for remote build
remote-build: export VM_HOSTNAME?=windowsvm
remote-build: export VM_PASSWORD?=windowspassword


# Use multiple connections to increase download speed
ifneq (,$(filter https://% http://%,$(VM_ISO)))
REMOTE_ISO:=$(VM_ISO)
LOCAL_ISO=windows.iso
CONNECTIONS=16
$(LOCAL_ISO):
	aria2c -o $@ -q -j$(CONNECTIONS) -x$(CONNECTIONS) -s$(CONNECTIONS) "$(REMOTE_ISO)"
	sha256sum $@ | tee $(patsubst %.iso,%.sha256sum,$@)
build: $(LOCAL_ISO)
build: export VM_ISO:=$(LOCAL_ISO)
endif
