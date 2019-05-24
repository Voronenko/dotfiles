#!/bin/bash
# CREDITS https://github.com/yktoo/yktools/blob/master/gnome-terminal-profile
#=======================================================================================================================

USAGE_INFO="Usage: $0 import|export <filename> <optional,profile GUID>"

# Check variables
mode="$1"
filename="$2"
[[ -z "$mode"     ]] && echo "No mode specified, ${USAGE_INFO}"
[[ -z "$filename" ]] && echo "No filename specified, ${USAGE_INFO}"

# Get default profile ID
defaultprofile="$(gsettings get org.gnome.Terminal.ProfilesList default)"
defaultprofile="${defaultprofile:1:-1}" # remove leading and trailing single quotes

profile=${3:-$defaultprofile}


# To check oll possible profiles
# gsettings get org.gnome.Terminal.ProfilesList list

case "$mode" in
    # Export profile
    export)
        dconf dump "/org/gnome/terminal/legacy/profiles:/:$profile/" > "$filename"
        echo "Saved the default profile ${profile} in ${filename}"
        ;;

    # Import profile
    import)
        [[ ! -r "$filename" ]] && err "Failed to read from file $filename"
        dconf load "/org/gnome/terminal/legacy/profiles:/:$profile/" < "$filename"
        echo "Loaded ${filename} into the default profile ${profile}"
        ;;

    *)
        echo "Incorrect mode: $mode"
        echo ${USAGE_INFO}
        ;;
esac
