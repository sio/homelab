FIO?=fio
FILENAME?=/tmp/fio.bin
.DEFAULT_GOAL=read

define section_names_awk
/^\s*\[[^\]]+\]/ {
	gsub(/(\[|\])/, "");
	if ($$0 == "global") next;
	print $$0;
}
endef

CONFIG?=$(patsubst %.mk,%.config,$(lastword $(MAKEFILE_LIST)))
LOG?=$(patsubst %.config,%.log,$(CONFIG))
SECTIONS?=$(shell awk '$(section_names_awk)' $(CONFIG))

OPTIONS+=$(ARGS)

SIZE?=10G
OFFSET?=0
export SIZE OFFSET
ifneq (,$(findstring /dev/,$(FILENAME)))
OPTIONS+=--allow_file_create=0
else
OPTIONS+=--size=$(SIZE)
endif

OPTIONS+=--eta=always --eta-interval=2s --eta-newline=10s
OPTIONS+=$(foreach section,$(SECTIONS),--section=$(section))

read: SECTIONS:=$(filter read-%,$(SECTIONS))
write: SECTIONS:=$(filter write-%,$(SECTIONS))
rw: SECTIONS:=$(filter rw-%,$(SECTIONS))
all: SECTIONS:=$(filter-out .%,$(SECTIONS))

.PHONY: read write rw all
read write rw all:
	@tail -n0 -F "$(LOG)" & bg=$$!; trap '{ set +x; } 2>/dev/null; trap - EXIT INT TERM HUP; sleep 0.5; printf "\n\n"; kill $$bg' EXIT INT TERM HUP; \
	exec >>$(LOG) 2>&1; set -eux; \
	$(FIO) --version; \
	$(FIO) --parse-only --showcmd $(CONFIG) --filename=$(FILENAME) $(OPTIONS); \
	$(FIO)                        $(CONFIG) --filename=$(FILENAME) $(OPTIONS)
	@$(MAKE) results-$(if $(word 2,$(SECTIONS)),$@,$(SECTIONS))

.PHONY: $(SECTIONS)
$(SECTIONS):
	@$(MAKE) all SECTIONS=$@ --no-print-directory

.PHONY: verify
verify: .write-verify .verify

.PHONY: results results-%
results:
	@awk "$$results_filter_awk" "$(LOG)"
results-%:
	@$(MAKE) results PREFIX=$* --no-print-directory

.PHONY: errors
errors:
	@grep -P '\berr=\s*[^0\s]' "$(LOG)" || echo "$(LOG): no fio errors"

define results_filter_awk
BEGIN {
	print "\nBENCHMARK RESULTS\n--";
}
/^$(subst all,,$(PREFIX))[a-zA-Z0-9_\.-]*:.*groupid=.*jobs=/ {
	print;
	in_section=1;
	next;
}
/:.*groupid=.*jobs=/ {
	in_section=0;
}
/^  (read|write):/ {
	if (in_section) print;
}
END {
	printf "\n";
}
endef
export results_filter_awk
