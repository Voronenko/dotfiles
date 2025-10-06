#!/bin/bash

codium --list-extensions | xargs -L 1 echo codium --install-extension > install_codium_extensions.sh
