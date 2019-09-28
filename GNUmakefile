# https://www.client9.com/self-documenting-makefiles/
help:
	@echo Raspberry Pi Config tooling
	@echo
	@echo Targets:
	@awk -F ':|##' '/^[^\t].+?:.*?##/ { printf "  %-30s %s\n", $$1, $$NF  }' $(MAKEFILE_LIST)

.DEFAULT_GOAL=help
.PHONY=help

CURL := curl --progress-bar --location
MKDIR_P := mkdir -p
RM_F := rm -rf
TAR := tar
SED := sed

Skeleton_Dirs := \
	archives \
	build \
	config

skel: $(Skeleton_Dirs)
$(Skeleton_Dirs):
	@$(MKDIR_P) $@

distclean: ## Clean all files (including archives)
	@$(RM_F) $(Skeleton_Dirs)

clean: ## Clean build files
	@$(RM_F) build

include mk.d/buildroot.mk
include mk.d/sysimage.mk
include mk.d/ssh.mk
