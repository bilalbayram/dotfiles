all: sync

DOTFILES_DIR := $(CURDIR)

define link_path
	@if [ ! -e "$(1)" ]; then \
		echo "missing source: $(1)"; \
		exit 1; \
	fi; \
	if [ -L "$(2)" ]; then \
		current=$$(readlink "$(2)"); \
		if [ "$$current" = "$(1)" ]; then \
			echo "linked: $(2)"; \
		else \
			rm -f "$(2)"; \
			ln -s "$(1)" "$(2)"; \
			echo "relinked: $(2)"; \
		fi; \
	elif [ -e "$(2)" ]; then \
		echo "kept existing non-symlink: $(2)"; \
	else \
		ln -s "$(1)" "$(2)"; \
		echo "linked: $(2)"; \
	fi
endef

define unlink_path
	@if [ -L "$(1)" ]; then \
		current=$$(readlink "$(1)"); \
		case "$$current" in \
			"$(DOTFILES_DIR)"/*) \
				rm -f "$(1)"; \
				echo "unlinked: $(1)"; \
				;; \
			*) \
				echo "kept external symlink: $(1) -> $$current"; \
				;; \
		esac; \
	elif [ -e "$(1)" ]; then \
		echo "kept unmanaged path: $(1)"; \
	else \
		echo "already missing: $(1)"; \
	fi
endef

sync:
	mkdir -p ~/.config/fish
	mkdir -p ~/.config/zed
	mkdir -p ~/Library/"Application Support"/VSCodium/User

	$(call link_path,$(DOTFILES_DIR)/config.fish,$(HOME)/.config/fish/config.fish)
	$(call link_path,$(DOTFILES_DIR)/fish/functions,$(HOME)/.config/fish/functions)
	$(call link_path,$(DOTFILES_DIR)/vscodium-settings.json,$(HOME)/Library/Application Support/VSCodium/User/settings.json)
	$(call link_path,$(DOTFILES_DIR)/vscodium-keybindings.json,$(HOME)/Library/Application Support/VSCodium/User/keybindings.json)
	$(call link_path,$(DOTFILES_DIR)/zed-settings.json,$(HOME)/.config/zed/settings.json)
	$(call link_path,$(DOTFILES_DIR)/zed-keymap.json,$(HOME)/.config/zed/keymap.json)

	# don't show last login message
	touch ~/.hushlogin

clean:
	$(call unlink_path,$(HOME)/.config/fish/config.fish)
	$(call unlink_path,$(HOME)/.config/fish/functions)
	$(call unlink_path,$(HOME)/Library/Application Support/VSCodium/User/settings.json)
	$(call unlink_path,$(HOME)/Library/Application Support/VSCodium/User/keybindings.json)
	$(call unlink_path,$(HOME)/.config/zed/settings.json)
	$(call unlink_path,$(HOME)/.config/zed/keymap.json)

tr-keyboard:
	mkdir -p ~/.config/karabiner
	$(call link_path,$(DOTFILES_DIR)/karabiner.json,$(HOME)/.config/karabiner/karabiner.json)

status:
	@bash "$(DOTFILES_DIR)/scripts/dotfiles-status.sh"

audit:
	@bash "$(DOTFILES_DIR)/scripts/audit.sh"

cleanup-dry-run:
	@bash "$(DOTFILES_DIR)/scripts/cleanup-dry-run.sh"

brew:
	brew bundle --file="$(DOTFILES_DIR)/Brewfile" --cleanup

macos:
	bash "$(DOTFILES_DIR)/macos-defaults.sh"

background:
	bash "$(DOTFILES_DIR)/background-sync.sh"

.PHONY: all clean sync tr-keyboard status audit cleanup-dry-run brew macos background
