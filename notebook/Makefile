register:
	cp ipynb.xml ~/.local/share/mime
	update-mime-database ~/.local/share/mime
	cp jupyter-sq-text.svg $(HOME)/.local/share/icons/jupyter_notebook.svg
	sudo cp jupyter-sq-text.svg /usr/share/icons/gnome/scalable/mimetypes/x-ipynb+json.svg
	sudo gtk-update-icon-cache /usr/share/icons/gnome/ -f || true
	desktop-file-install --dir="$(HOME)/.local/share/applications" jupyter.desktop
