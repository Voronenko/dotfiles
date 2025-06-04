update:
	zellij setup --dump-config > /home/slavko/dotfiles/config/zellij/config.kdl
plugins: pl-zjstatus pl-zj-docker pl-zellij-forgot pl-zellij-bookmarks pl-harpoon pl-ghost
	@echo "Installed plugins"
pl-zjstatus:
	mkdir -p ~/dotfiles/config/zellij/plugins/
	TAG=$$(curl -s https://api.github.com/repos/dj95/zjstatus/releases/latest | grep tag_name | cut -d '"' -f 4); \
	curl -sLo ~/dotfiles/config/zellij/plugins/zjstatus.wasm "https://github.com/dj95/zjstatus/releases/download/$$TAG/zjstatus.wasm"; \
	curl -sLo ~/dotfiles/config/zellij/plugins/zjframes.wasm "https://github.com/dj95/zjstatus/releases/download/$$TAG/zjframes.wasm"
pl-zj-docker:
	mkdir -p ~/dotfiles/config/zellij/plugins/
	TAG=$$(curl -s https://api.github.com/repos/dj95/zj-docker/releases/latest | grep tag_name | cut -d '"' -f 4); \
	curl -sLo ~/dotfiles/config/zellij/plugins/zj-docker.wasm "https://github.com/dj95/zj-docker/releases/download/$$TAG/zj-docker.wasm"
pl-zellij-forgot:
	mkdir -p ~/dotfiles/config/zellij/plugins/
	TAG=$$(curl -s https://api.github.com/repos/karimould/zellij-forgot/releases/latest | grep tag_name | cut -d '"' -f 4); \
	curl -sLo ~/dotfiles/config/zellij/plugins/zellij_forgot.wasm "https://github.com/karimould/zellij-forgot/releases/download/$$TAG/zellij_forgot.wasm"
pl-zellij-bookmarks:
	mkdir -p ~/dotfiles/config/zellij/plugins/
	TAG=$$(curl -s https://api.github.com/repos/yaroslavborbat/zellij-bookmarks/releases/latest | grep tag_name | cut -d '"' -f 4); \
	curl -sLo ~/dotfiles/config/zellij/plugins/zellij-bookmarks.wasm "https://github.com/yaroslavborbat/zellij-bookmarks/releases/download/$$TAG/zellij-bookmarks.wasm"
pl-harpoon:
	mkdir -p ~/dotfiles/config/zellij/plugins/
	TAG=$$(curl -s https://api.github.com/repos/Nacho114/harpoon/releases/latest | grep tag_name | cut -d '"' -f 4); \
	curl -sLo ~/dotfiles/config/zellij/plugins/harpoon.wasm "https://github.com/Nacho114/harpoon/releases/download/$$TAG/harpoon.wasm"
pl-ghost:
	mkdir -p ~/dotfiles/config/zellij/plugins/
	TAG=$$(curl -s https://api.github.com/repos/vdbulcke/ghost/releases/latest | grep tag_name | cut -d '"' -f 4); \
	curl -sLo ~/dotfiles/config/zellij/plugins/ghost.wasm "https://github.com/vdbulcke/ghost/releases/download/$$TAG/ghost.wasm"





