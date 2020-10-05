# REPACK DEBIAN INSTALLER IMAGE WITH SOME MODIFICATIONS
# 	https://wiki.debian.org/DebianInstaller/Modify/CD
# 	https://wiki.debian.org/RepackBootableISO


# Configurable parameters
REMOTE_ISO?=https://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/10.6.0+nonfree/amd64/iso-cd/firmware-10.6.0-amd64-netinst.iso
INPUT_ISO?=input.iso
OUTPUT_ISO?=output.iso
PRESEED?=preseed.cfg
CONTENT_DIR?=isocontent
CONTENT_PATCH?=$(patsubst %.iso,%.patch,$(INPUT_ISO))


# Internal variables
CMAKE?=cmake
ISO_MBR_HEADER?=$(CONTENT_DIR)/../isohdpfx.bin
ISO_EFI_PARTITION?=$(CONTENT_DIR)/../isoefipart.bin
EFI?=yes
ifeq (yes,$(EFI))
BOOT_EFI_ARGS=-bios /usr/share/qemu/OVMF.fd
export EFI
endif
BOOT_DISK?=


.PHONY: env-check
env-check:
	test -e $(INPUT_ISO)
	$(CMAKE) --version
	xorriso --version


.PHONY: env
env:
	apt update
	apt install \
		cmake \
		isolinux \
		syslinux-utils \
		xorriso \


debian-preseed-image: export PRESEED=../debian10/baremetal.cfg
debian-preseed-image: export CONTENT_PATCH=debian-10.patch
debian-preseed-image:
	$(MAKE) repack


.PHONY: unpack
unpack: $(CONTENT_DIR)


.PHONY: patch
patch: patch-menu


.PHONY: patch-menu
patch-menu: $(CONTENT_DIR) $(CONTENT_PATCH) $(PRESEED)
	cd $(CONTENT_DIR) && patch -p0 --no-backup-if-mismatch < $(abspath $(CONTENT_PATCH))
	cp $(PRESEED) $(CONTENT_DIR)/preseed.cfg


.PHONY: patch-initrd
patch-initrd: $(CONTENT_DIR) $(PRESEED)
	export INITRD_GZ=$$(find $(CONTENT_DIR) -regextype egrep -regex '.*install\.\w*/initrd.gz') && \
	gunzip $$INITRD_GZ && \
	echo $(PRESEED) | cpio -H newc -o -A -F $${INITRD_GZ%.gz} && \
	gzip $${INITRD_GZ%.gz}


.PHONY: repack
repack: $(OUTPUT_ISO)


.PHONY: clean
clean:
	$(RM) -r \
		"$(CONTENT_DIR)" \
		"$(OUTPUT_ISO)" \
		"$(OUTPUT_ISO).sha256sum" \


.PHONY: diff
diff:
ifndef CONTENT_ORIG
	$(error Variable not defined: CONTENT_ORIG)
endif
	diff -ruN --ignore-trailing-space $(CONTENT_ORIG) $(CONTENT_DIR) > $(CONTENT_PATCH) || true
	sed -i \
		-e 's:^--- $(CONTENT_ORIG)/*:--- :g' \
		-e 's:^+++ $(CONTENT_DIR)/*:+++ :g' \
		$(CONTENT_PATCH)


.PHONY: boot
boot:
	kvm \
		-m 1024M \
		-smp cpus=2,sockets=2 \
		-machine type=pc,accel=kvm \
		-cpu qemu64 \
		-device virtio-net,netdev=user.0 \
		-vnc 127.0.0.1:99 \
		-device qemu-xhci \
		-drive id=pendrive,file=$(OUTPUT_ISO),format=raw,if=none \
		-device usb-storage,drive=pendrive \
		-boot menu=on \
		$(BOOT_EFI_ARGS) $(BOOT_DISK_ARGS) \
		-netdev user,id=user.0,hostfwd=tcp::4040-:5985


../debian10/baremetal.cfg:
	$(MAKE) -C $(dir $@) $(notdir $@)


ifdef BOOT_DISK
BOOT_DISK_ARGS=-drive file=$(BOOT_DISK),if=virtio,format=qcow2
boot: $(BOOT_DISK)
$(BOOT_DISK):
	qemu-img create -f qcow2 $(BOOT_DISK) 10G
endif


$(INPUT_ISO):
	curl \
		-o $@ \
		-L "$(REMOTE_ISO)"
	$(MAKE) $@.sha256sum --assume-old=$@


%.iso.sha256sum: %.iso
	sha256sum $< > $@


$(CONTENT_DIR): $(INPUT_ISO) | env-check
	mkdir -p $(CONTENT_DIR)
	export ISO=$(abspath $(INPUT_ISO)); \
	cd $(CONTENT_DIR) && $(CMAKE) -E tar xf $$ISO
	chmod -R +w $(CONTENT_DIR)


.INTERMEDIATE: $(ISO_MBR_HEADER)
$(ISO_MBR_HEADER):
	dd if=$(INPUT_ISO) bs=1 count=432 of=$@


$(OUTPUT_ISO): $(CONTENT_DIR) $(ISO_MBR_HEADER) patch | env-check
	cd $(CONTENT_DIR) && \
		md5sum $$(find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f) \
		> md5sum.txt
	xorriso \
		-as mkisofs \
		-r \
		-o $(OUTPUT_ISO) \
		-isohybrid-mbr $(ISO_MBR_HEADER) \
		-b $$(find $(CONTENT_DIR) -name isolinux.bin -type f -printf '%P\n') \
		-c $$(find $(CONTENT_DIR) -name boot.cat -type f -printf '%P\n') \
		-boot-load-size 4 \
		-boot-info-table \
		-no-emul-boot \
		-eltorito-alt-boot \
		-e $$(find $(CONTENT_DIR) -name efi.img -type f -printf '%P\n') \
		-no-emul-boot \
		-isohybrid-gpt-basdat \
		-isohybrid-apm-hfsplus \
		$(CONTENT_DIR)
	$(MAKE) $(OUTPUT_ISO).sha256sum --assume-old=$(OUTPUT_ISO)
