HOST?=workstation
export TF_VAR_hostname=$(HOST)

include Makefile.terraform
Makefile.terraform:
	curl -sSL "$(HELPERS_SOURCE)/Makefile" -o "$@"

HELPERS=yandex.tf yandex.tfrc
HELPERS_SOURCE=https://github.com/sio/gitlab-runners-fleet/raw/terraform/deploy
$(TERRAFORM_VERBS): $(HELPERS)
$(HELPERS):
	curl -sSL "$(HELPERS_SOURCE)/$@" -o "$@"
