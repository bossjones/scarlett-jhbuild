# include .mk

SHELL=/bin/bash

# verify that certain variables have been defined off the bat
check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Undefined $1$(if $(value 2), ($(strip $2)))))

list_allowed_args  := name inventory

mkfile_path        := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir        := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))

PR_SHA             := $(shell git rev-parse HEAD)
REPO_ORG           := bossjones
REPO_NAME          := scarlett-jhbuild
REPO_SLUG          := $(REPO_ORG)/$(REPO_NAME)
IMAGE_TAG          := $(REPO_SLUG):$(PR_SHA)
TEST_IMAGE_NAME    := $(IMAGE_TAG)
CONTAINER_NAME     := $(shell echo -n $(IMAGE_TAG) | openssl dgst -sha1 | sed 's/^.* //'  )
MKDIR              = mkdir

.PHONY: list
list:
	@$(MAKE) -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

.PHONY: yamllint-role
yamllint-role:
	bash -c "find .* -type f -name '*.y*ml' -print0 | xargs -I FILE -t -0 -n1 yamllint FILE"

# NOTE: This assumes that all of your repos live in the same workspace!
link_modulesets:
	# add aliases for dotfiles
	@for file in $(shell find $(CURDIR)/modulesets -name "*scarlett*modules" -print); do \
		echo $$file; \
		f=$$(basename $$file); \
		ln -sfn $$file $$HOME/jhbuild/modulesets/$f; \
	done; \
	ls -lta $$HOME/jhbuild/modulesets/$f; \
