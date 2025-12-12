FIO?=fio
FILENAME?=/tmp/fio.bin
SIZE=10G

.DEFAULT_GOAL=read
OPTIONS?=$(foreach section,$(SECTIONS),--section=$(section))
CONFIG?=$(patsubst %.mk,%.config,$(lastword $(MAKEFILE_LIST)))
LOG?=$(patsubst %.config,%.log,$(CONFIG))
SECTIONS?=$(shell awk '$(section_names_awk)' $(CONFIG))

define section_names_awk
/^\s*\[[^\]]+\]/ {
	gsub(/(\[|\])/, "");
	if ($$0 == "global") next;
	print $$0;
}
endef

ifneq (,$(findstring /dev/,$(FILENAME)))
OPTIONS+=--allow-file-create=0
else
OPTIONS+=--size=$(SIZE)
endif
OPTIONS+=--eta=always --eta-interval=2s --eta-newline=10s

read: SECTIONS:=$(filter read-%,$(SECTIONS))
write: SECTIONS:=$(filter write-%,$(SECTIONS))
rw: SECTIONS:=$(filter rw-%,$(SECTIONS))
all: SECTIONS=

.PHONY: read write rw all
read write rw all:
	$(FIO) --filename=$(FILENAME) $(OPTIONS) $(CONFIG) | tee --append $(LOG)
	@$(MAKE) results-$@

.PHONY: $(SECTIONS)
$(SECTIONS):
	@$(MAKE) all SECTIONS=$@ --no-print-directory
	@$(MAKE) results PREFIX=$@ --no-print-directory

.PHONY: results results-%
results:
	@echo '\nBENCHMARK RESULTS\n--'; grep -P "$(subst all,,$(PREFIX))[\w-]*:.*groupid=.*jobs=" -A1 $(LOG)
results-%:
	@$(MAKE) results PREFIX=$* --no-print-directory
