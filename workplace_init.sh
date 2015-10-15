#!/bin/sh

mv ~/.atom/keymap.cson ~/.atom/keymap.cson || true
ln -s $PWD/atom/keymap.cson ~/.atom/keymap.cson
