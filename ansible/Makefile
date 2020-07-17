INVENTORY?=~/inventory.yml
SHELL=/bin/bash

PLAYBOOK_RUNNER?=ansible-playbook
PLAYBOOK_TIMER?=time
PLAYBOOK_ARGS?=

PLAYBOOKS=$(patsubst %.yml,%,$(wildcard *.yml))


ifeq (,$(wildcard $(INVENTORY)))
$(error Inventory file not found: $(INVENTORY))
endif


# Ask for vault password if inventory is encrypted
# (wildcard performs tilde expansion)
ifneq (,$(findstring $$ANSIBLE_VAULT,$(firstword $(file < $(wildcard $(INVENTORY))))))
PLAYBOOK_ARGS+=--ask-vault-pass
endif


.PHONY: environment-versions
environment-versions:
	$(PLAYBOOK_RUNNER) --version


.PHONY: $(PLAYBOOKS)
$(PLAYBOOKS): | environment-versions
	$(PLAYBOOK_TIMER) $(PLAYBOOK_RUNNER) -i $(INVENTORY) $(PLAYBOOK_ARGS) $@.yml
