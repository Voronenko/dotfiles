#
```
mkvirtualenv project_notes --python=/usr/local/bin/python3
pip install -r ~/dotfiles/notebook/requirements.txt 
```

# portions of https://github.com/Voronenko/znotebook


In Ipython, first,

import iplantuml
then, create a cell like,

%%plantuml

@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response
@enduml



# Discover where are configs are stored

```
jupyter --paths
```

# Missing config ?

```
jupyter notebook --generate-config
Writing default config to: /home/slavko/.jupyter/jupyter_notebook_config.py
```

# Useful extensions

https://github.com/timkpaine/jupyterlab_templates

```
pip install jupyterlab_templates
jupyter labextension install jupyterlab_templates
jupyter serverextension enable --py jupyterlab_templates
```
