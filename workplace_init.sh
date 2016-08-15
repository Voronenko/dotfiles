#!/bin/sh

mv ~/.atom/keymap.cson ~/.atom/keymap.cson.old || true
ln -s $PWD/atom/keymap.cson ~/.atom/keymap.cson

mv ~/.atom/config.cson ~/.atom/config.cson.old || true
ln -s $PWD/atom/config.cson ~/.atom/config.cson

mkdir -p ~/.zsh/completion
curl -L https://raw.githubusercontent.com/sdurrheimer/docker-compose-zsh-completion/master/_docker-compose > ~/.zsh/completion/_docker-compose
exec $SHELL -l

# and add
#fpath=(~/.zsh/completion $fpath)
#autoload -Uz compinit && compinit -i
