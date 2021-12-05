GITHUB="https://github.com"

[[ -z "$TFENV_HOME" ]] && export TFENV_HOME="$HOME/.tfenv"

_zsh_tfenv_install() {
    echo "Installing tfenv..."
    git clone "${GITHUB}/tfutils/tfenv.git"         "${TFENV_HOME}"
}

_zsh_tfenv_load() {
    # export PATH
    export PATH="$TFENV_HOME/bin:$PATH"
}

# install tfenv if it isnt already installed
[[ ! -f "$TFENV_HOME/bin/tfenv" ]] && _zsh_tfenv_install

# load tfenv if it is installed
if [[ -f "$TFENV_HOME/bin/tfenv" ]]; then
    _zsh_tfenv_load
fi
