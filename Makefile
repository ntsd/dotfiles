SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos /opt/homebrew /home/linuxbrew/.linuxbrew)
ASDF_PATH := $(HOME)/.asdf
PATH := $(HOMEBREW_PREFIX)/bin:$(DOTFILES_DIR)/bin:$(PATH)
SHELL := env PATH=$(PATH) /bin/bash
SHELLS := /private/etc/shells
BIN := $(HOMEBREW_PREFIX)/bin
export XDG_CONFIG_HOME := $(HOME)/.config
export STOW_DIR := $(DOTFILES_DIR)

.PHONY: test

all: $(OS)

macos: sudo core-macos macos-packages link packages copilot-global 

linux: core-linux link

# post link packages
packages: asdf-packages node-packages

core-macos: brew bash git oh-my-zsh

core-linux:
	apt-get update
	apt-get upgrade -y
	apt-get dist-upgrade -f

stow-macos: brew
	is-executable stow || brew install stow

stow-linux: core-linux
	is-executable stow || apt-get -y install stow

sudo:
ifndef GITHUB_ACTION
	sudo -v
	while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
endif

macos-packages: brew-packages cask-apps

link: stow-$(OS)
	# backup old dotfiles
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE -a ! -h $(HOME)/$$FILE ]; then \
		mv -v $(HOME)/$$FILE{,.bak}; fi; done
	mkdir -p $(XDG_CONFIG_HOME)
	stow -t $(HOME) runcom
	stow -t $(XDG_CONFIG_HOME) config

.PHONY: copilot
copilot: stow-$(OS)
	@echo "Select instruction files from config/copilot/instructions to activate in .github/instructions";
	bin/copilot-select
	@echo "Workspace chat modes in .github/chatmodes are already active.";
	@echo "Run 'make copilot-global' for optional user-level linking.";

.PHONY: copilot-global
copilot-global: stow-$(OS)
	@echo "Linking user-level Copilot instructions, chat modes, and agents (advanced)."
	mkdir -p "$(HOME)/Library/Application Support/Code - Insiders/User/prompts"
	find "$(HOME)/Library/Application Support/Code - Insiders/User/prompts" -type l -exec rm {} \; || true
	if [ -d "$(DOTFILES_DIR)/config/copilot/chatmodes" ]; then \
		for FILE in $(DOTFILES_DIR)/config/copilot/chatmodes/*.chatmode.md; do \
			ln -sf "$$FILE" "$(HOME)/Library/Application Support/Code - Insiders/User/prompts/$$(basename $$FILE)"; \
		done; \
		echo "✓ Linked user-level chat modes"; \
	fi
	if [ -d "$(DOTFILES_DIR)/config/copilot/agents" ]; then \
		for FILE in $(DOTFILES_DIR)/config/copilot/agents/*.agent.md; do \
			ln -sf "$$FILE" "$(HOME)/Library/Application Support/Code - Insiders/User/prompts/$$(basename $$FILE)"; \
		done; \
		echo "✓ Linked custom agent files"; \
	fi
	@echo "✓ Global Copilot linking complete."

unlink: stow-$(OS)
	stow --delete -t $(HOME) runcom
	stow --delete -t $(XDG_CONFIG_HOME) config
	# restore old dotfiles
	for FILE in $$(\ls -A runcom); do if [ -f $(HOME)/$$FILE.bak ]; then \
		mv -v $(HOME)/$$FILE.bak $(HOME)/$${FILE%%.bak}; fi; done

brew:
	is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

asdf:
	[[ -d $(ASDF_PATH) ]] || git clone https://github.com/asdf-vm/asdf.git $(ASDF_PATH)

oh-my-zsh:
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

bash: brew
ifdef GITHUB_ACTION
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(shell which bash) $(SHELLS) && \
		sudo chsh -s $(shell which bash); \
	fi
else
	if ! grep -q bash $(SHELLS); then \
		brew install bash bash-completion@2 pcre && \
		sudo append $(shell which bash) $(SHELLS) && \
		chsh -s $(shell which bash); \
	fi
endif

git: brew
	brew list git || brew install git
	brew list git || brew install git-extras

brew-packages: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Brewfile

cask-apps: brew
	brew bundle --file=$(DOTFILES_DIR)/install/Caskfile || true
	for EXT in $$(cat install/VSCodefile); do code-insiders --install-extension $$EXT; done

asdf-packages: asdf
	. $(ASDF_PATH)/asdf.sh && cd $(HOME) && \
		cut -d' ' -f1 .tool-versions|xargs -I{} asdf plugin add {} && \
		asdf install

node-packages: asdf
	. $(ASDF_PATH)/asdf.sh && $(ASDF_PATH)/shims/npm install -g $(shell cat install/npmfile) && $(ASDF_PATH)/shims/npm install -g $(shell cat runcom/.default-npm-packages)

test:
	bats test

