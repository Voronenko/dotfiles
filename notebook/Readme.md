# Story behind using jupyter notebooks as a personal synchronized "evernote"

https://medium.com/@V_Voronenko/your-personal-knowledge-base-with-jupyterlab-cc22147ad56e

# Initialization
```
mkvirtualenv project_notes --python=/usr/local/bin/python3
pip install -r ~/dotfiles/notebook/requirements.txt 
```


# Using PlantUML diagrams in notes


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

https://github.com/parente/jupyterlab-quickopen

```
pip install jupyterlab-quickopen
jupyter labextension install @parente/jupyterlab-quickopen
```

# Adjusting style appearence

If you want to adjust css appearence a bit, there is built-in way to affect UI
by placing necessary HTML snippet into code cell via

```
from IPython.core.display import display, HTML
display(HTML("<style>.container { width:100% !important; }</style>"))
```


# Activating NB Contrib extensions

NB Contrib extensions is not compatible with LAB which has the extension API.
Instead, look for good extensions

As an option - activate "discovery" option:

Go into advanced settings editor.

Open the Extension Manager section.

Add the entry "enabled": true.

Save the settings.


Look for extensions

