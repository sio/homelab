MOLECULE?=$(VENV)/molecule
MOLECULE+=--base-config "$(MOLECULE_BASE_CONFIG)"
MOLECULE+=$(MOLECULE_EXTRA_ARGS)
MOLECULE_BASE_CONFIG?=$(abspath molecule.yml)
MOLECULE_EXTRA_ARGS?=
ifdef DEBUG
MOLECULE_EXTRA_ARGS+=--debug
endif


ANSIBLE?=$(VENV)/ansible
ANSIBLE_ROLES=$(patsubst %/molecule,%,$(wildcard ../roles/*/molecule))


MOLECULE_ACTIONS=\
	cleanup \
	converge \
	create \
	dependency \
	destroy \
	idempotence \
	lint \
	login \
	prepare \
	side_effect \
	syntax \
	test \
	verify


define message
Usage: $(MAKE) [target]

List of supported targets
    all
        Execute Molecule tests for all Ansible roles. Default target
    test ANSIBLE_ROLE=../roles/somerole
        Execute Molecule tests for a specific role
    login ANSIBLE_ROLE=../roles/somerole
        Login to Docker container after applying Ansible role
    show-roles
        Show roles with Molecule tests
    help
        Show this help message
endef
export message


all: $(ANSIBLE_ROLES)


define test-ansible-role
.PHONY: $(1)
$(1): | venv versions
	cd $(1) && $$(MOLECULE) test
endef
$(foreach role,$(ANSIBLE_ROLES),$(eval $(call test-ansible-role, $(role))))


.PHONY: $(MOLECULE_ACTIONS)
$(MOLECULE_ACTIONS): | venv versions
	cd $(ANSIBLE_ROLE) && $(MOLECULE) $@


.PHONY: show-roles
show-roles:
	@echo -e "    $(subst $(eval) ,\n    ,$(foreach role,$(sort $(ANSIBLE_ROLES)),$(role)))"


.PHONY: versions
versions: venv
	$(VENV)/python --version
	$(MOLECULE) --version
	$(ANSIBLE) --version


.PHONY: help
help:
	@echo "$$message"


.PHONY: check
check:
	./check-readme.sh


include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2019.12.05/Makefile.venv"
	echo "1b0a2f89b322ea86958d63ed4ae718846ccaaf939e5e24180524f28dede238ba *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv


# This value is assigned immediately upon parsing Makefile, thus it must be
# placed after include statement where $(VENV) is defined
export PATH:=$(VENV):$(PATH)
