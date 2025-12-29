all: sync

sync:
	mkdir -p ~/.config/fish
	mkdir -p ~/.config/zed
	mkdir -p ~/.config/opencode
	mkdir -p ~/Library/"Application Support"/Cursor/User

	[ -f ~/.config/fish/config.fish ] || ln -s "$(CURDIR)/config.fish" ~/.config/fish/config.fish
	[ -d ~/.config/fish/functions/ ] || ln -s "$(CURDIR)/fish/functions" ~/.config/fish/functions

	[ -f ~/.config/opencode/opencode.json ] || ln -s "$(CURDIR)/.config/opencode/opencode.json" ~/.config/opencode/opencode.json
	[ -f ~/.config/opencode/oh-my-opencode.json ] || ln -s "$(CURDIR)/.config/opencode/oh-my-opencode.json" ~/.config/opencode/oh-my-opencode.json

	[ -f ~/Library/"Application Support"/Cursor/User/settings.json ] || ln -s "$(CURDIR)/cursor-settings.json" ~/Library/"Application Support"/Cursor/User/settings.json
	[ -f ~/Library/"Application Support"/Cursor/User/keybindings.json ] || ln -s "$(CURDIR)/cursor-keybindings.json" ~/Library/"Application Support"/Cursor/User/keybindings.json

	[ -f ~/.config/zed/settings.json ] || ln -s "$(CURDIR)/zed-settings.json" ~/.config/zed/settings.json
	[ -f ~/.config/zed/keymap.json ] || ln -s "$(CURDIR)/zed-keymap.json" ~/.config/zed/keymap.json

	# don't show last login message
	touch ~/.hushlogin

clean:
	rm -f ~/.config/fish/config.fish
	rm -rf ~/.config/fish/functions/
	rm -f ~/Library/"Application Support"/Cursor/User/settings.json
	rm -f ~/Library/"Application Support"/Cursor/User/keybindings.json
	rm -f ~/.config/zed/settings.json
	rm -f ~/.config/zed/keymap.json
	rm -f ~/.config/opencode/opencode.json
	rm -f ~/.config/opencode/oh-my-opencode.json

tr-keyboard:
	mkdir -p ~/.config/karabiner
	[ -f ~/.config/karabiner/karabiner.json ] || ln -s "$(CURDIR)/karabiner.json" ~/.config/karabiner/karabiner.json

brew:
	brew bundle --file="$(CURDIR)/Brewfile" --cleanup

macos:
	bash "$(CURDIR)/macos-defaults.sh"

.PHONY: all clean sync tr-keyboard brew
