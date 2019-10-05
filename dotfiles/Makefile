#
# Automatically trigger correct bootstrap.sh actions with GNU Make
#


BOOTSTRAP=$(dir $(firstword $(MAKEFILE_LIST)))bootstrap.sh
DOT=$(dir $(BOOTSTRAP))
TOPICS=$(patsubst $(DOT)%/, %, $(filter %/, $(wildcard $(DOT)*/)))
LISTS=$(patsubst $(DOT)topics-%.list, %, $(wildcard $(DOT)topics-*.list))


define help_message
Usage: $(MAKE) TOPIC [TOPIC2 ...] LISTNAME [LISTNAME2 ...]

Will trigger correct $(BOOTSTRAP) actions:
  For TOPIC:
    $(BOOTSTRAP) TOPIC
  For LISTNAME:
    $(BOOTSTRAP) $(DOT)topics-LISTNAME.list

See '$(BOOTSTRAP) --help' for more information
endef
export help_message


.PHONY: help
help:
	@echo "$$help_message"


.PHONY: $(TOPICS)
$(TOPICS):
	$(BOOTSTRAP) $@


.PHONY: $(LISTS)
$(LISTS):
	$(BOOTSTRAP) $(DOT)topics-$@.list
