#!/bin/sh

gem install tmuxinator
pip3 install --user tmuxp
# tmuxp import tmuxinator /path/to/file.{json,yaml}

mkdir -p ~/.atom

mv ~/.atom/keymap.cson ~/.atom/keymap.cson.old || true
ln -s $PWD/atom/keymap.cson ~/.atom/keymap.cson

mv ~/.atom/config.cson ~/.atom/config.cson.old || true
ln -s $PWD/atom/config.cson ~/.atom/config.cson

mkdir -p ~/.config/Code/User

mv ~/.config/Code/User/settings.json ~/.config/Code/User/settings.old || true
ln -s $PWD/code/settings.json ~/.config/Code/User/settings.json

mv ~/.config/Code/User/keybindings.json ~/.config/Code/User/keybindings.old || true
ln -s $PWD/code/keybindings.json ~/.config/Code/User/keybindings.json


mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/sdurrheimer/docker-compose-zsh-completion/master/_docker-compose > ~/.zsh/completion/_docker-compose
curl -L https://raw.githubusercontent.com/eriwen/gradle-completion/master/_gradle > ~/.zsh/completion/_gradle
exec $SHELL -l

# and add
#fpath=(~/.zsh/completion $fpath)
#autoload -Uz compinit && compinit -i
