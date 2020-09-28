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
ISO_HEADER?=$(CONTENT_DIR)/../isohdpfx.bin


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
unpack: $(CONTENT_DIR) | env-check


.PHONY: patch
patch:


.PHONY: repack
repack: $(OUTPUT_ISO) | env-check


.PHONY: clean
clean:
	$(RM) -r \
		"$(OUTPUT_ISO)" \
		"$(CONTENT_DIR)" \


$(INPUT_ISO):
	curl \
		-o $@ \
		-L "$(REMOTE_ISO)"
	sha256sum $@ > $@.sha256sum


$(CONTENT_DIR): $(INPUT_ISO)
	mkdir -p $(CONTENT_DIR)
	$(CMAKE) -E tar -xf $(INPUT_ISO) -C $(CONTENT_DIR)
	chmod -R +w $(CONTENT_DIR)


.INTERMEDIATE: $(ISO_HEADER)
$(ISO_HEADER):
	dd if=$(INPUT_ISO) bs=1 count=432 of=$@


$(OUTPUT_ISO): $(CONTENT_DIR) $(ISO_HEADER)
	cd $(CONTENT_DIR) && \
		md5sum $$(find ! -name "md5sum.txt" ! -path "./isolinux/*" -follow -type f) \
		> md5sum.txt
	xorriso \
		-as mkisofs \
		-o $(OUTPUT_ISO) \
		-isohybrid-mbr $(ISO_HEADER) \
		-c isolinux/boot.cat \
		-b isolinux/isolinux.bin \
		-no-emul-boot \
		-boot-load-size 4 \
		-boot-info-table \
		$(CONTENT_DIR)
