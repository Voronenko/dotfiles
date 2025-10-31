link-zed-settings:
	@echo ">>> Linking Zed settings..."
	@mkdir -p ~/.config/zed
	@if [ -e ~/.config/zed/settings.json ] && [ ! -L ~/.config/zed/settings.json ]; then \
		echo "Backing up existing settings.json to settings.json.bak"; \
		mv ~/.config/zed/settings.json ~/.config/zed/settings.json.bak; \
	fi
	@ln -sf ~/dotfiles/config/zed/settings.json ~/.config/zed/settings.json
	@echo "Symlink created: ~/.config/zed/settings.json -> ~/dotfiles/config/zed/settings.json"
