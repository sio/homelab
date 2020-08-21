.PHONY: toc
toc:
	scripts/toc-md.sh . TOC.md


MIRROR_TEMP=.temp-mirror
.PHONY: mirror
mirror:
	git clone --bare "https://gitlab.com/sio/server_common.git" $(MIRROR_TEMP)
	git -C $(MIRROR_TEMP) push --mirror "git@github.com:sio/homelab.git"
	$(RM) -r $(MIRROR_TEMP)


# https://reddit.com/r/selfhosted/comments/idikkz
SYSBENCH?=sysbench
.PHONY: sysbench
sysbench:
	@$(SYSBENCH) --version  # Fail early if sysbench is not installed
	@$(MAKE) .sysbench-run | tee --append $@


.PHONY: .sysbench-run
.sysbench-run:
	@date
	$(SYSBENCH) --threads=4 --cpu-max-prime=10000 cpu run
	$(SYSBENCH) --threads=4 memory run
