#!/bin/bash

set -e

mkdir -p ~/z_personal_notes
cp *.ipynb ~/z_personal_notes
virtualenv -p python3 ~/.virtualenvs/project_notes
source ~/.virtualenvs/project_notes/bin/activate
pip3 install jupyterlab
pip3 install bash_kernel
python3 -m bash_kernel.install
pip3 install iplantuml
