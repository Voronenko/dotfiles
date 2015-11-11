#!/bin/sh

mv ~/.atom/keymap.cson ~/.atom/keymap.cson.old || true
ln -s $PWD/atom/keymap.cson ~/.atom/keymap.cson
