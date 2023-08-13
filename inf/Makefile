# put a .env file here that includes terraform variables for various stacks.
ifneq (,$(wildcard ./.env))
  include .env
endif


.PHONY: all
all: format lint

# 2164: add || exit after cd to catch errors - we can't catch errors in bootstraps
SHELLCHECK_EXCLUDE := "--exclude=SC2164"


.PHONY: lint
lint:
	terraform fmt --check -recursive
	shellcheck $(SHELLCHECK_EXCLUDE) modules/github_actions_runner_asg/bootstrap*

.PHONY: format
format:
	terraform fmt -recursive

.PHONY: clean
clean:
	rm ./*.plan

# you need to add all the combos of the plan files here otherwise they'll get automatically deleted in gnu make
.SECONDARY: python-package-index_dev.plan python-package-index_staging.plan python-package-index_prod.plan
.SECONDARY: ot3-ci_dev.plan ot3-ci_staging.plan ot3-ci_prod.plan

streq=$(and $(findstring $(1),$(2)),$(findstring $(2),$(1)))
stackname=$(firstword $(subst _, ,$(1)))
workspacename=$(word 2, $(subst _, ,$(1)))
check_stackname=$(if $(shell ls $(call stackname,$(1))),,$(error No stack $(call stackname,$(1)) (must be a stack subdirectory of this directory). Rules are spelled as stack-name_workspacename e.g. python-package-index_dev))
check_workspacename=$(if $(findstring $(call workspacename,$(1)),prod dev staging),,$(error No workspace $(call workspacename,$(1)) in $(1) (must be dev, staging, or prod). Rules are spelled as stack-name_workspacename e.g. python-package-index_dev))

%.plan: ./*/*.tf ./*/*/*.tf ./*/*.tfvars ./*/*/*.tmpl
	@echo "Finding stack and workspace in $*"
	$(call check_stackname,$*)
	$(call check_workspacename,$*)
	@echo "Planning for stack $(call stackname,$*) workspace $(call workspacename,$*)"
	terraform -chdir=$(call stackname,$*) init
	terraform -chdir=$(call stackname,$*) workspace select $(call workspacename,$*)
	terraform -chdir=$(call stackname,$*) plan -var-file=$(call stackname,$*).tfvars -out=../$@

.PHONY: plan-%
plan-%: %.plan
	@echo "Plan complete for $*"

define confirm
  @echo Confirming before running terraform apply on $(1) $(2)
  @echo Retype the stack name $(1) and press enter. To cancel press CTRL-C.
  @read && [[ $$REPLY == $(1) ]]
  @echo Retype the workspace name $(2) and press enter. To cancel press CTRL-C.
  @read && [[ $$REPLY == $(2) ]]
  @echo Correct readback, applying
endef

.PHONY: apply-%
apply-%: %.plan
	-@$(call check_stackname,$*)
	-@$(call check_workspacename,$*)
	$(call confirm,$(call stackname,$*),$(call workspacename,$*))
	terraform -chdir=$(call stackname,$*) apply ../$<
