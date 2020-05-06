# Story behind using jupyter notebooks as a personal synchronized "evernote"

https://medium.com/@V_Voronenko/your-personal-knowledge-base-with-jupyterlab-cc22147ad56e

## Initialization

```sh
mkvirtualenv project_notes --python=/usr/local/bin/python3
pip install -r ~/dotfiles/notebook/requirements.txt 
```


## Using PlantUML diagrams in notes


In Ipython, first,

import iplantuml
then, create a cell like,

```
%%plantuml

@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response
@enduml
```



## Discover where are configs are stored

```sh
jupyter --paths
```

## Discover kernels activated in your instance

```sh
ipython kernelspec list
```

## Registering custom kernel

Below is copy of notes from https://github.com/softasap/sa-jupyterhub, but generally applicable as well.

Create new kernel using conda or typical virtualenv.

Note: you might need to prepare your shell for usage with conda by invoking

```sh
conda init <SHELL_NAME>
/usr/local/anaconda/bin/conda search "^python$"
...
python                         3.8.2      h191fe78_0  pkgs/main
python                         3.8.2      hcf32534_0  pkgs/main
```

choose python version and create virtual environment

```sh
/usr/local/anaconda/bin/conda create -n Anaconda3.6 python=3.6 anaconda
```

once created, activate previously created environment

```sh
conda activate Anaconda3.6
```

make sure env is activated and install ipykernel

```sh
(Anaconda3.6) jupyter@bionic:~$ pip install ipykernel
```

Register Anaconda3.6 for use on your jupyter notebooks:

```sh
python -m ipykernel install --user --name Anaconda3.6 --display-name  "Python 3.6 - anaconda venv"
Installed kernelspec Anaconda3.6 in /home/jupyter/.local/share/jupyter/kernels/anaconda3.6
```

you are done:

```sh
 jupyter kernelspec list
Available kernels:
  anaconda3.6    /home/jupyter/.local/share/jupyter/kernels/anaconda3.6
  python3        /usr/local/share/jupyter/kernels/python3

```

Note, that kernel registration is nothing more as json file cat /home/vagrant/.local/share/jupyter/kernels/anaconda3.6/kernel.json

```json
{
 "argv": [
  "/home/vagrant/.conda/envs/Anaconda3.6/bin/python",
  "-m",
  "ipykernel_launcher",
  "-f",
  "{connection_file}"
 ],
 "display_name": "Python 3.6 - anaconda venv",
 "language": "python"
}
```


## Missing config ?

```
jupyter notebook --generate-config
Writing default config to: /home/slavko/.jupyter/jupyter_notebook_config.py
```

## Useful extensions

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

## Adjusting style appearence

If you want to adjust css appearence a bit, there is built-in way to affect UI
by placing necessary HTML snippet into code cell via

```
from IPython.core.display import display, HTML
display(HTML("<style>.container { width:100% !important; }</style>"))
```


## Activating NB Contrib extensions

NB Contrib extensions is not compatible with LAB which has the extension API.
Instead, look for good extensions

As an option - activate "discovery" option:

Go into advanced settings editor.

Open the Extension Manager section.

Add the entry "enabled": true.

Save the settings.


Look for extensions


## Searching in files

At a moment no good extension with UI, so search is limited to console

nbgrep - to look in code cells https://github.com/Voronenko/dotfiles/blob/master/bin/nbgrep


nbgrepmd - to look in markdown cells https://github.com/Voronenko/dotfiles/blob/master/bin/nbgrepmd
