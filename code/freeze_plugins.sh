#!/bin/bash

code --list-extensions | xargs -L 1 echo code --install-extension > install_code_extensions.sh
