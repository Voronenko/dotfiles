link-kitty-conf:
	@echo ">>> Linking Kitty settings..."
	@mkdir -p ~/.config/kitty
	@if [ -e ~/.config/kitty/kitty.conf ] && [ ! -L ~/.config/kitty/kitty.conf ]; then \
		echo "Backing up existing kitty.conf to kitty.conf.bak"; \
		mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak; \
	fi
	@ln -sf ~/dotfiles/config/kitty/kitty.conf ~/.config/kitty/kitty.conf
	@echo "Symlink created: ~/.config/kitty/kitty.conf -> ~/dotfiles/config/kitty/kitty.conf"
