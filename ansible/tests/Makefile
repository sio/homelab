MOLECULE?=$(VENV)/molecule
MOLECULE+=--base-config "$(abspath $(MOLECULE_BASE_CONFIG))"
MOLECULE+=$(MOLECULE_EXTRA_ARGS)
MOLECULE_BASE_CONFIG?=molecule.yml
MOLECULE_EXTRA_ARGS?=
ifdef DEBUG
MOLECULE_EXTRA_ARGS+=--debug
export VIRSH_DEBUG=1
export LIBVIRT_DEBUG=2
export LIBGUESTFS_DEBUG=1
endif
ifdef MOLECULE_SCENARIO
MOLECULE_ACTION_ARGS+=--scenario-name $(MOLECULE_SCENARIO)
endif


ANSIBLE?=$(VENV)/ansible
ANSIBLE_ROLES=$(patsubst %/molecule,%,$(wildcard ../roles/*/molecule))


VENVDIR?=$(abspath ./.venv)


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


YAMLLINT_CONFIG_FILE=$(abspath yamllint.yml)
export YAMLLINT_CONFIG_FILE


ANSIBLE_STDOUT_CALLBACK?=yaml
export ANSIBLE_STDOUT_CALLBACK


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
	cd $(1) && $$(MOLECULE) test $(MOLECULE_ACTION_ARGS)
endef
$(foreach role,$(ANSIBLE_ROLES),$(eval $(call test-ansible-role, $(role))))


.PHONY: $(MOLECULE_ACTIONS)
$(MOLECULE_ACTIONS): | venv versions
	cd $(ANSIBLE_ROLE) && $(MOLECULE) $@ $(MOLECULE_ACTION_ARGS)


.PHONY: show-roles
show-roles:
	@echo -e "    $(subst $(eval) ,\n    ,$(foreach role,$(sort $(ANSIBLE_ROLES)),$(role)))"


.PHONY: versions
versions: MOLECULE_EXTRA_ARGS=
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


.PHONY: check-debian-release
check-debian-release:
	@for RELEASE in debian10 debian11; \
	do \
		ERRORS=$$(find .. -name molecule.yml \
			! -path '*/.*/*' \
			! -path '../tests/molecule.yml' \
			-exec grep -LE "^[^#]*$$RELEASE" {} \;) ;\
		[ -z "$$ERRORS" ] || { \
			echo "Missing test instance for: $$RELEASE"; \
			echo "$$ERRORS"; \
			RETCODE=199; \
		}; \
	done; \
	[ -z "$$RETCODE" ] || exit $$RETCODE;


molecule-git.pip:  # cooperation with https://gitlab.com/sio/ci-with-molecule-git
	curl -o "$@" -L "https://gitlab.com/sio/ci-with-molecule-git/-/raw/master/molecule-git.pip"


include Makefile.venv
Makefile.venv:
	curl \
		-o Makefile.fetched \
		-L "https://github.com/sio/Makefile.venv/raw/v2020.08.14/Makefile.venv"
	echo "5afbcf51a82f629cd65ff23185acde90ebe4dec889ef80bbdc12562fbd0b2611 *Makefile.fetched" \
		| sha256sum --check - \
		&& mv Makefile.fetched Makefile.venv


# This value is assigned immediately upon parsing Makefile, thus it must be
# placed after include statement where $(VENV) is defined
export PATH:=$(VENV):$(PATH)
