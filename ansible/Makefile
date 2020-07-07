INVENTORY?=~/inventory.yml

PLAYBOOK_RUNNER?=ansible-playbook
PLAYBOOK_TIMER?=time
PLAYBOOK_ARGS?=

PLAYBOOKS=$(patsubst %.yml,%,$(wildcard *.yml))


.PHONY: environment-versions
environment-versions:
	$(PLAYBOOK_RUNNER) --version


.PHONY: $(PLAYBOOKS)
$(PLAYBOOKS): | environment-versions
	$(PLAYBOOK_TIMER) $(PLAYBOOK_RUNNER) -i $(INVENTORY) $(PLAYBOOK_ARGS) $@.yml
