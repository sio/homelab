INFRA?=~/infra
INVENTORY?=$(INFRA)/inventory.yml
SHELL=/bin/bash

PLAYBOOK_RUNNER?=ansible-playbook
PLAYBOOK_TIMER?=time
PLAYBOOK_ARGS?=

ANSIBLE_STDOUT_CALLBACK?=yaml
export ANSIBLE_STDOUT_CALLBACK

export ANSIBLE_LOOKUP_PLUGINS=plugins/lookup

export PY_COLORS=1
export ANSIBLE_FORCE_COLOR=1


PLAYBOOKS=$(patsubst %.yml,%,$(wildcard *.yml))


-include Makefile.secrets
Makefile.secrets: | $(HOME)/.ssh/config.d/infra.cfg
	-ln -vs $(INFRA)/Makefile.secrets $@
$(HOME)/.ssh/config.d/infra.cfg:
	mkdir -p $(dir $@)
	-ln -vs $(INFRA)/ssh_client.cfg $@


ifeq (,$(wildcard $(INVENTORY)))
$(error Inventory file not found: $(INVENTORY))
endif


# Ask for vault password if inventory is encrypted
# (wildcard performs tilde expansion)
ifeq  (,$(findstring -vault-pass,$(PLAYBOOK_ARGS)))
ifneq (,$(findstring $$ANSIBLE_VAULT,$(firstword $(file < $(wildcard $(INVENTORY))))))
PLAYBOOK_ARGS+=--ask-vault-pass
endif
endif


# Convenient way to limit target hosts
ifdef HOSTS
PLAYBOOK_ARGS+=--limit "$(HOSTS)"
endif


# Read inventory directory
PLAYBOOK_ARGS+=-i ./inventory/


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
		[[ ! -z "$$NON_INTERACTIVE" ]] && { \
			echo Can not query for passphrase in non-interactive mode; \
			exit 105; \
		}; \
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


# Create virtual environment if Ansible is not installed
ifeq (,$(shell command -v $(PLAYBOOK_RUNNER)))
environment-versions: | venv
PLAYBOOK_RUNNER=$(VENV)/ansible-playbook
include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2020.08.14/Makefile.venv"
	echo "5afbcf51a82f629cd65ff23185acde90ebe4dec889ef80bbdc12562fbd0b2611 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv
endif
