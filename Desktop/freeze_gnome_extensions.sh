#!/bin/bash

gsettings get org.gnome.shell enabled-extensions > gnome_extensions.txt
echo "========================Local:" >> gnome_extensions.txt
ls ~/.local/share/gnome-shell/extensions/ >> gnome_extensions.txt
