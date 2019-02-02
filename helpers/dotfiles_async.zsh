# ideas from https://github.com/geometry-zsh/geometry
source source ${HOME}/dotfiles/helpers/async.zsh 2> /dev/null

# Callback handler to properly render RPROMPT with calculated output
-dotfiles-async-callback() {
    local job="$1" code="$2" output="$3" exec_time="$4" stderr="$5"
    RPROMPT="${(j/::/)output}"
    zle && zle reset-prompt

    # Explicitely stop async worker
    async_stop_worker dotfiles_async_worker
}

# Wrapper to call rprompt renderer, needed to set up workers status
-dotfiles-async-prompt() {
    # In order to work with zsh-async we need to set workers in
    # the proper directory.
    # TODO
}

# Flushed currently running async jobs and queues a new one
# See https://github.com/mafredri/zsh-async#async_flush_jobs-worker_name
-dotfiles-async-job() {
    # See https://github.com/mafredri/zsh-async#async_start_worker-worker_name--u--n--p-pid
    async_start_worker dotfiles_async_worker -u -n # unique, notify through SIGWINCH
    async_register_callback dotfiles_async_worker -dotfiles-async-callback

    async_flush_jobs dotfiles_async_worker
    async_job dotfiles_async_worker -dotfiles-async-prompt $PWD
}

# Initialize zsh-async and creates a worker
dotfiles_async_setup() {
    # Workaround for missing zsh-async lib
    if (( ! $+functions[async_init] )); then
      source ${HOME}/dotfiles/helpers/async.zsh 2> /dev/null || { echo "Error: Could not load zsh-async library." >&2; return 1 }
    fi

    async_init

    # Submit a new job every precmd
    add-zsh-hook precmd -dotfiles-async-job
}
