.ONESHELL:
SHELL = bash

.DEFAULT_GOAL := all

install-asdf-tools:
	@echo -e "\n# installing asdf stuff\n"
	-asdf plugin add terragrunt
	-asdf plugin add terraform
	-asdf plugin add direnv
	-asdf plugin add jq https://github.com/ryodocx/asdf-jq
	cat .tool-versions | xargs -L1 asdf install
	asdf reshim

git-update-submodules:
	@echo -e "\n# updating submodules\n"
	git submodule update --init --recursive

all: git-update-submodules install-asdf-tools
