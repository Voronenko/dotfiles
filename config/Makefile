link: lazy-docker kubie lazy-cli
	echo OK
lazy-docker:
	rm ~/.config/lazydocker/config.yml || true
	ln -s ~/dotfiles/config/lazydocker/config.yml ~/.config/lazydocker/config.yml
kubie:
	mkdir -p ~/.kube
	rm ~/.kube/kubie.yaml || true
	ln -s ~/dotfiles/config/kubie/kubie.yaml ~/.kube/kubie.yaml
lazy-cli:
	rm ~/.config/lazycli/config.yml || true
	ln -s ~/dotfiles/config/lazycli/config.yml ~/.config/lazycli/config.yml
zellij:
	rm  ~/.config/zellij/config.kdl || true
	ln -s ~/dotfiles/config/zellij/config.kdl ~/.config/zellij/config.kdl
zellij-bookmarks:
	rm ~/.config/zellij/.zellij_bookmarks.yaml || true
	ln -s ~/dotfiles/config/zellij/zellij_bookmarks.yaml ~/.config/zellij/.zellij_bookmarks.yaml
zellij-bookmarks-local:
	rm ~/dotfiles/config/zellij/.zellij_bookmarks.yaml || true
	cd zellij && ln -s zellij_bookmarks.yaml .zellij_bookmarks.yaml
