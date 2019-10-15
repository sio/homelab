#
# Automatically trigger correct bootstrap.sh actions with GNU Make
#

# NOTE TO SELF:
#   Replacing bootstrap.sh with a Makefile is tempting and looks possible -
#   right until the moment we need to handle whitespace in filenames.
#   Current shell implementation quotes all values, so whitespace is supported
#   everywhere.


BOOTSTRAP=$(dir $(firstword $(MAKEFILE_LIST)))bootstrap.sh
DOT=$(dir $(BOOTSTRAP))
TOPICS=$(patsubst $(DOT)%/, %, $(filter %/, $(wildcard $(DOT)*/)))
LISTS=$(patsubst $(DOT)topics-%.list, %, $(wildcard $(DOT)topics-*.list))


define newline


endef
define help_message
Usage: make TOPIC [TOPIC2 ...] LISTNAME [LISTNAME2 ...]

Will trigger correct $(BOOTSTRAP) actions:
  For TOPIC:
    $(BOOTSTRAP) TOPIC
  For LISTNAME:
    $(BOOTSTRAP) $(DOT)topics-LISTNAME.list

See '$(BOOTSTRAP) --help' for more information

Known topics:
   $(subst $(eval)  ,$(newline)    ,$(foreach item, $(sort $(TOPICS)), $(item)))

Known topic lists:
   $(subst $(eval)  ,$(newline)    ,$(foreach item, $(sort $(LISTS)), $(item)))
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
