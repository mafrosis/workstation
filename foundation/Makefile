.PHONY: all test

ORG_ID?=412577173587
ORG?=gcp.mafro.dev
FOUNDATIONS_PREFIX?=foundations

all: foundation write-sa-key

.PHONY: init
init: _remove-dot-terraform .terraform
	@true

.PHONY: _remove-dot-terraform
_remove-dot-terraform:
	@rm -rf .terraform

.terraform:
	terraform init -backend-config=bucket=$(FOUNDATIONS_PREFIX)-$(ORG_ID)

.PHONY: foundation
foundation: .terraform
	terraform apply \
		-var-file=$(ORG).tfvars \
		-var my_ip=$$(curl ifconfig.co) \
		-auto-approve

.PHONY: write-sa-key
write-sa-key:
	@terraform output project_service_account_key | base64 --decode > credentials.json
	@mv credentials.json $(PWD)/$$(terraform output project_id).json
	@echo "Credentials written to $$(terraform output project_id).json"

.PHONY: clean
clean:
	terraform destroy -var-file=$(ORG).tfvars -var my_ip=1.0.0.1 -force
