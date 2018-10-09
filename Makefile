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

# Docker stuff ( taken from boss-docker-jhbuild-pygobject3 )
project := $(REPO_NAME)
projects := $(REPO_NAME)
username := bossjones
container_name := $(REPO_NAME)
CONTAINER_VERSION  = $(shell \cat ./VERSION | awk '{print $1}')
GIT_BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
GIT_SHA     = $(shell git rev-parse HEAD)

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
		cp -fv $$file $$HOME/jhbuild/modulesets/$f; \
	done; \
	ls -lta $$HOME/jhbuild/modulesets/$f; \

render_jhbuildrc:
	@scripts/render_jhbuild.py --cmd render

docker_run:
	.ci/docker-run.sh

bootstrap: jhbuild_bootstrap render link_modulesets jhbuild_list

jhbuild_bootstrap:
	python3 scripts/render_jhbuild.py --cmd bootstrap

compile_jhbuild:
	python3 scripts/render_jhbuild.py --cmd compile

render:
	python3 scripts/render_jhbuild.py --cmd render

render-system:
	sudo touch /etc/ld.so.conf.d/jhbuild-scarlett-deps-x86_64.conf
	sudo chown $(shell id -u):$(shell id -u) -R /etc/ld.so.conf.d/jhbuild-scarlett-deps-x86_64.conf
	python3 scripts/render_jhbuild.py --system --cmd render
	sudo chown root:root -R /etc/ld.so.conf.d/jhbuild-scarlett-deps-x86_64.conf

jhbuild_list:
	jhbuild list

pip-deps:
	pip install --upgrade pip && pip install pygobject==3.28.3 ptpython black isort ipython pdbpp Pillow matplotlib numpy_ringbuffer MonkeyType autopep8 pylint flake8 pytest

create-full-local-hierachy:
	bash scripts/create-full-local-hierachy.sh

clone-sphinx:
	python3 scripts/render_jhbuild.py --cmd clone-one --pkg sphinxbase

clone-pocketsphinx:
	python3 scripts/render_jhbuild.py --cmd clone-one --pkg pocketsphinx

mv-sphinx:
	mv -fv ~/gnome/* ~/src/

dev-env: pip-deps create-full-local-hierachy clone-sphinx mv-sphinx

docker_build:
	./scripts/docker-build.sh $(GIT_SHA) $(REPO_ORG) $(REPO_NAME)

download-roles:
	ansible-galaxy install -r requirements.yml --roles-path ./roles/

jhbuild-all:
	~/.local/bin/jhbuild build python-365; \
	~/.local/bin/jhbuild build meta-scarlett-bootstrap; \
	~/.local/bin/jhbuild build pygobject; \
	~/.local/bin/jhbuild build pygobject; \

build-deb:
	scripts/mkpkg-deb.sh

docker_tag:
	./scripts/docker-tag.sh $(GIT_SHA) $(REPO_ORG) $(REPO_NAME)

docker_dev:
	./scripts/docker-build.sh $(GIT_SHA) $(REPO_ORG) $(REPO_NAME)
	./scripts/docker-tag.sh $(GIT_SHA) $(REPO_ORG) $(REPO_NAME)
	./scripts/docker-dev.sh $(GIT_SHA) $(REPO_ORG) $(REPO_NAME)

deb-test-build:
	docker build --build-arg HOST_USER_ID=$(shell id -u) --tag "$(REPO_ORG)/$(REPO_NAME)-simple:latest" \
	--file "Dockerfile.simple" $(shell pwd)

run-fpm-bash: cp-deb
	docker run  --rm --security-opt label=disable --volume "$$(pwd)/:/home/developer/app" --workdir "/home/developer/app" --tty --interactive "$(REPO_ORG)/$(REPO_NAME)-simple:latest" bash

gpr:
	git pull --rebase

.PHONY: cp-deb
cp-deb:
	cp -av ~/*.deb .
	@for file in $(shell find $$HOME/ -name "*.deb" -print); do \
		echo $$file; \
		f=$$(basename $$file); \
		cp -fv $$file $(CURDIR)/$f; \
	done; \
	ls -lta $(CURDIR)/$f; \
