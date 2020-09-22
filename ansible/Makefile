INFRA?=~/infra
INVENTORY?=$(INFRA)/inventory.yml
SHELL=/bin/bash

PLAYBOOK_RUNNER?=ansible-playbook
PLAYBOOK_TIMER?=time
PLAYBOOK_ARGS?=

PLAYBOOKS=$(patsubst %.yml,%,$(wildcard *.yml))


-include Makefile.secrets
Makefile.secrets:
	@ln -s $(INFRA)/Makefile.secrets $@ 2>/dev/null || true


ifeq (,$(wildcard $(INVENTORY)))
$(error Inventory file not found: $(INVENTORY))
endif


# Ask for vault password if inventory is encrypted
# (wildcard performs tilde expansion)
ifneq (,$(findstring $$ANSIBLE_VAULT,$(firstword $(file < $(wildcard $(INVENTORY))))))
PLAYBOOK_ARGS+=--ask-vault-pass
endif


# Convenient way to limit target hosts
ifdef HOSTS
PLAYBOOK_ARGS+=--limit "$(HOSTS)"
endif


.PHONY: environment-versions
.DEFAULT_GOAL := environment-versions
environment-versions:
	@date
	$(PLAYBOOK_RUNNER) --version


.PHONY: $(PLAYBOOKS)
$(PLAYBOOKS): | environment-versions
	$(PLAYBOOK_TIMER) $(PLAYBOOK_RUNNER) -i $(INVENTORY) $(PLAYBOOK_ARGS) $@.yml


# Add identities to ssh-agent
SSH_KEYS_PRIVATE?=
SSH_AGENT_LIFETIME?=24h


.PHONY: keys
keys:
	@new_keys=""; \
	for key in $(SSH_KEYS_PRIVATE); \
	do \
		[[ -e "$$key" ]] \
		|| { echo "Identity file not found: $$key"; exit 101; }; \
		fingerprint=$$(ssh-keygen -lf "$$key"|cut -d\  -f2); \
		ssh-add -l \
		|  grep -q "$$fingerprint" \
		|| new_keys="$$new_keys $$key"; \
	done; \
	if [[ ! -z "$$new_keys" ]]; \
	then \
		echo "Adding identities to ssh-agent..."; \
		ssh-add -t $(SSH_AGENT_LIFETIME) $$new_keys; \
	fi


.PHONY: .require-hosts
.require-hosts:
ifndef HOSTS
	$(error Required variable is not defined: HOSTS)
endif


# Shutdown must only be called with a specific list of hosts
shutdown: .require-hosts


# Customization for all.yml
all: export ANSIBLE_DISPLAY_OK_HOSTS=no
all: export ANSIBLE_DISPLAY_SKIPPED_HOSTS=no
all: keys
