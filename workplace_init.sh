#!/bin/sh

mv ~/.atom/keymap.cson ~/.atom/keymap.cson.old || true
ln -s $PWD/atom/keymap.cson ~/.atom/keymap.cson

mv ~/.atom/config.cson ~/.atom/config.cson.old || true
ln -s $PWD/atom/config.cson ~/.atom/config.cson

