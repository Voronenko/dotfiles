#!/usr/bin/env bash

set -e

default_fg='colour255'
default_bg='colour34'
default_secondary_bg='colour236'


tmux_option() {
    local -r value=$(tmux show-option -gqv "$1")
    local -r default="$2"

    if [ ! -z "$value" ]; then
        echo "$value"
    else
        echo "$default"
    fi
}


badges() {
    tmux show-option -g | cut -f 1 -d ' ' | grep '@badge' | grep -v '_\(fg\|bg\|fmt\)'
}


generate() {
    local option=$1
    local name=$(tmux_option "$option")
    local comm=$(tmux_option "${option}_fmt")
    local fg_color=$(tmux_option "${option}_fg" "$default_fg")
    local bg_color=$(tmux_option "${option}_bg" "$default_bg")
    local secondary_fg=$(tmux_option "${option}_secondary_fg" "$fg_color")
    local secondary_bg=$(tmux_option "${option}_secondary_bg" "$default_secondary_bg")

    echo "#[fg=$fg_color,bg=$bg_color] $name #[fg=$secondary_fg,bg=$secondary_bg] $comm #[fg=default]#[bg=default]"
}


highlight() {
    local status="$1"
    local option="${2:1}"   # strip the leading @
    local genstr="$3"
    local status_value=$(tmux_option "$status")
    local place_holder="#{$option}"
    tmux set-option -gq "$status" "${status_value//$place_holder/$genstr}"
}


main() {
    for option in $(badges); do
        local genstr=$(generate "$option")
        highlight "status-left"  "$option" "$genstr"
        highlight "status-right" "$option" "$genstr"
    done
}
main
