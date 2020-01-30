MOLECULE_EXTRA_ARGS?=
MOLECULE_BASE_CONFIG?=$(abspath molecule.yml)


ANSIBLE?=$(VENV)/ansible
MOLECULE?=$(VENV)/molecule


MOLECULE+=--base-config "$(MOLECULE_BASE_CONFIG)"
MOLECULE+=$(MOLECULE_EXTRA_ARGS)


../role/motd: ANSIBLE_ROLE=$@
../role/motd: test


.PHONY: test
test: | venv versions
	cd $(ANSIBLE_ROLE) && $(MOLECULE) test


.PHONY: versions
versions: venv
	$(VENV)/python --version
	$(MOLECULE) --version
	$(ANSIBLE) --version


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
