#!/bin/bash

antigravity --list-extensions | xargs -L 1 echo antigravity --install-extension > install_antigravity_extensions.sh
