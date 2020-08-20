.PHONY: toc
toc:
	scripts/toc-md.sh . TOC.md


MIRROR_TEMP=.temp-mirror
.PHONY: mirror
mirror:
	git clone --bare "https://gitlab.com/sio/server_common.git" $(MIRROR_TEMP)
	git -C $(MIRROR_TEMP) push --mirror "git@github.com:sio/homelab.git"
	$(RM) -r $(MIRROR_TEMP)
