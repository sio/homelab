# REPACK DEBIAN INSTALLER IMAGE WITH SOME MODIFICATIONS
# 	https://wiki.debian.org/DebianInstaller/Modify/CD
# 	https://wiki.debian.org/RepackBootableISO


# Configurable parameters
REMOTE_ISO?=https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.6.0-amd64-netinst.iso
INPUT_ISO?=input.iso
OUTPUT_ISO?=output.iso
CONTENT_DIR?=isocontent
CONTENT_PATCH?=$(patsubst %.iso,%.patch,$(INPUT_ISO))


# Internal variables
CMAKE?=cmake
ISO_MBR_HEADER?=$(CONTENT_DIR)/../isohdpfx.bin
ISO_EFI_PARTITION?=$(CONTENT_DIR)/../isoefipart.bin
BOOT_EFI?=yes
ifeq (yes,$(BOOT_EFI))
BOOT_EFI_ARGS=-bios /usr/share/qemu/OVMF.fd
endif


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


.PHONY: unpack
unpack: $(CONTENT_DIR)


.PHONY: patch
patch:


.PHONY: repack
repack: $(OUTPUT_ISO)


.PHONY: clean
clean:
	$(RM) -r \
		"$(CONTENT_DIR)" \
		"$(OUTPUT_ISO)" \
		"$(OUTPUT_ISO).sha256sum" \


.PHONY: boot
boot:
	kvm \
		-m 1024M \
		-smp cpus=2,sockets=2 \
		-machine type=pc,accel=kvm \
		-cpu qemu64 \
		-device virtio-net,netdev=user.0 \
		-vnc 127.0.0.1:99 \
		-cdrom $(OUTPUT_ISO) \
		$(BOOT_EFI_ARGS) \
		-netdev user,id=user.0,hostfwd=tcp::4040-:5985


$(INPUT_ISO):
	curl \
		-o $@ \
		-L "$(REMOTE_ISO)"
	$(MAKE) $@.sha256sum


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


$(OUTPUT_ISO): $(CONTENT_DIR) $(ISO_MBR_HEADER) | env-check
	cd $(CONTENT_DIR) && \
		md5sum $$(find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f) \
		> md5sum.txt
	xorriso \
		-as mkisofs \
		-o $(OUTPUT_ISO) \
		-isohybrid-mbr $(ISO_MBR_HEADER) \
		-c $$(find $(CONTENT_DIR) -name boot.cat -type f -printf '%P\n') \
		-b $$(find $(CONTENT_DIR) -name isolinux.bin -type f -printf '%P\n') \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		$(CONTENT_DIR)
	$(MAKE) $(OUTPUT_ISO).sha256sum
