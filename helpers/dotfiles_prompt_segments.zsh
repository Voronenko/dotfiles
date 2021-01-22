################################################################
# Prompt Segment Definitions
################################################################

# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context time battery dir vcs virtualenv custom_wifi_signal)
# POWERLEVEL9K_CUSTOM_WIFI_SIGNAL="echo signal: \$(nmcli device wifi | grep yes | awk '{print \$8}')"
# POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_BACKGROUND="blue"
# POWERLEVEL9K_CUSTOM_WIFI_SIGNAL_FOREGROUND="yellow"

######################## DOTFILES SIMPLE PROMPTS

prompt_dot_status() {
  "$1_prompt_segment" "$0" "$2" none none "%(?,,%{$fg[yellow]%}[%{$fg_bold[white]%}%?%{$reset_color%}%{$fg[yellow]%}])" ''
}

prompt_dot_git() {
  "$1_prompt_segment" "$0" "$2" none none "$(git_prompt_info)" ''
}

prompt_dot_dir() {
  "$1_prompt_segment" "$0" "$2" none none "%{$fg[cyan]%}%c%{$reset_color%}$(snpt "DOTFILES_UL_FINISH" "yellow")" ''
}

prompt_dot_ssh() {
   if [[ -n "${SSH_CONNECTION-}${SSH_CLIENT-}${SSH_TTY-}" ]]; then
  "$1_prompt_segment" "$0" "$2" none none "%{$fg_bold[yellow]%}⇕ ${USER}%{$reset_color%}" ''
   fi
}

prompt_dot_dck() {
   if [[ -f /.dockerenv ]]; then
  "$1_prompt_segment" "$0" "$2" none none "%{$fg_bold[red]%}⭕%{$reset_color%}" ''
   fi
}

prompt_dot_terraform() {
    # dont show 'default' workspace in home dir
    [[ "$PWD" == ~ ]] && return
    # check if in terraform dir
    if [ -d .terraform ]; then
      local workspace=$(terraform workspace show 2> /dev/null) || return
      "$1_prompt_segment" "$0" "$2" gray yellow "$(print_icon 'SERVER_ICON') ${workspace}" ''
    fi
}

prompt_dot_jenv() {
  local java_version_home=$(echo $JAVA_HOME | grep .jenv | grep -v system  2>/dev/null)
  if [[ ! -z $java_version_home ]]
  then
    local java_version=$(jenv version-name 2>/dev/null)
    "$1_prompt_segment" "$0" "$2" "red" "white" "$java_version" "JAVA_ICON"
  fi
}


# * * * * * /usr/bin/python /usr/local/bin/toggl now > ~/.toggl_now
prompt_dot_toggl() {
  if [[ -f ~/.toggl_now ]]; then
    TOGGLE_ACTIVITY=$(cat ~/.toggl_now | grep Project | awk '{print $2}' )
     if [[ "$TOGGLE_ACTIVITY" != "is" ]]; then
       if [[ ! -z "$TOGGLE_ACTIVITY" ]]; then
        "$1_prompt_segment" "$0" "$2" gray white "$(print_icon 'TODO_ICON') ${TOGGLE_ACTIVITY} " ''
       fi
     fi
  fi
}


########################
# AWS Profile
prompt_aws() {
  local aws_profile="${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}"
  local aws_region="${AWS_REGION:-$AWS_DEFAULT_REGION}"
#  local aws_orgname="${AWS_ORG_NAME}"
#  if [ "${aws_orgname}" = "None" ]; then
#    aws_orgname = ""
#  fi

  if [[ -n "${aws_profile}${aws_region}" ]]; then
    "$1_prompt_segment" "$0" "$2" red white "$aws_profile $aws_region" 'AWS_ICON'
  fi
}

prompt_mybr() {
  local lws newline
  [[ "$1" == "right" ]] && return
  newline="\n%{$fg[yellow]%}└──${ret_status}%{$reset_color%}"
  lws=$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS
  POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=
  "$1_prompt_segment" \
    "$0" \
    "$2" \
    "NONE" "NONE" "${newline}"
  POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=$lws
}

################################################################
# Context: user@hostname (who am I and where am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
set_default POWERLEVEL9K_ALWAYS_SHOW_CONTEXT false
set_default POWERLEVEL9K_ALWAYS_SHOW_USER false
set_default POWERLEVEL9K_CONTEXT_TEMPLATE "%n@%m"
prompt_context() {
  local current_state="DEFAULT"
  typeset -AH context_states
  context_states=(
    "ROOT"        "yellow"
    "SUDO"        "yellow"
    "DEFAULT"     "yellow"
    "REMOTE"      "yellow"
    "REMOTE_SUDO" "yellow"
  )

  local content=""

  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_CONTEXT" == true ]] || [[ "$(whoami)" != "$DEFAULT_USER" ]] || [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
      content="${POWERLEVEL9K_CONTEXT_TEMPLATE}"
  elif [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]]; then
      content="$(whoami)"
  else
      return
  fi

  if [[ $(print -P "%#") == '#' ]]; then
    current_state="ROOT"
  elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
    if [[ -n "$SUDO_COMMAND" ]]; then
      current_state="REMOTE_SUDO"
    else
      current_state="REMOTE"
    fi
  elif [[ -n "$SUDO_COMMAND" ]]; then
    current_state="SUDO"
  fi

  "$1_prompt_segment" "${0}_${current_state}" "$2" "$DEFAULT_COLOR" "${context_states[$current_state]}" "${content}"
}

################################################################
# User: user (who am I)
# Note that if $DEFAULT_USER is not set, this prompt segment will always print
set_default POWERLEVEL9K_USER_TEMPLATE "%n"
prompt_user() {
  local current_state="DEFAULT"
  typeset -AH user_state
  if [[ "$POWERLEVEL9K_ALWAYS_SHOW_USER" == true ]] || [[ "$(whoami)" != "$DEFAULT_USER" ]]; then
    if [[ $(print -P "%#") == '#' ]]; then
      user_state=(
        "STATE"               "ROOT"
        "CONTENT"             "${POWERLEVEL9K_USER_TEMPLATE}"
        "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
        "FOREGROUND_COLOR"    "yellow"
        "VISUAL_IDENTIFIER"   "ROOT_ICON"
      )
    elif [[ -n "$SUDO_COMMAND" ]]; then
      user_state=(
        "STATE"               "SUDO"
        "CONTENT"             "${POWERLEVEL9K_USER_TEMPLATE}"
        "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
        "FOREGROUND_COLOR"    "yellow"
        "VISUAL_IDENTIFIER"   "SUDO_ICON"
      )
    else
      user_state=(
        "STATE"               "DEFAULT"
        "CONTENT"             "$(whoami)"
        "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
        "FOREGROUND_COLOR"    "yellow"
        "VISUAL_IDENTIFIER"   "USER_ICON"
      )
    fi
    "$1_prompt_segment" "${0}_${user_state[STATE]}" "$2" "${user_state[BACKGROUND_COLOR]}" "${user_state[FOREGROUND_COLOR]}" "${user_state[CONTENT]}" "${user_state[VISUAL_IDENTIFIER]}"
  fi
}

################################################################
# Host: machine (where am I)
set_default POWERLEVEL9K_HOST_TEMPLATE "%m"
prompt_host() {
  local current_state="LOCAL"
  typeset -AH host_state
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    host_state=(
      "STATE"               "REMOTE"
      "CONTENT"             "${POWERLEVEL9K_HOST_TEMPLATE}"
      "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
      "FOREGROUND_COLOR"    "yellow"
      "VISUAL_IDENTIFIER"   "SSH_ICON"
    )
  else
    host_state=(
      "STATE"               "LOCAL"
      "CONTENT"             "${POWERLEVEL9K_HOST_TEMPLATE}"
      "BACKGROUND_COLOR"    "${DEFAULT_COLOR}"
      "FOREGROUND_COLOR"    "yellow"
      "VISUAL_IDENTIFIER"   "HOST_ICON"
    )
  fi
  "$1_prompt_segment" "$0_${host_state[STATE]}" "$2" "${host_state[BACKGROUND_COLOR]}" "${host_state[FOREGROUND_COLOR]}" "${host_state[CONTENT]}" "${host_state[VISUAL_IDENTIFIER]}"
}

################################################################
# The 'custom` prompt provides a way for users to invoke commands and display
# the output in a segment.
prompt_custom() {
  local segment_name="${3:u}"
  # Get content of custom segment
  local command="POWERLEVEL9K_CUSTOM_${segment_name}"
  local segment_content="$(eval ${(P)command})"

  if [[ -n $segment_content ]]; then
    "$1_prompt_segment" "${0}_${3:u}" "$2" $DEFAULT_COLOR_INVERTED $DEFAULT_COLOR "$segment_content" "CUSTOM_${segment_name}_ICON"
  fi
}

################################################################
# Determine the unique path - this is needed for the
# truncate_to_unique strategy.
#
function getUniqueFolder() {
  local trunc_path directory test_dir test_dir_length
  local -a matching
  local -a paths
  local cur_path='/'
  paths=(${(s:/:)1})
  for directory in ${paths[@]}; do
    test_dir=''
    for (( i=0; i < ${#directory}; i++ )); do
      test_dir+="${directory:$i:1}"
      matching=("$cur_path"/"$test_dir"*/)
      if [[ ${#matching[@]} -eq 1 ]]; then
        break
      fi
    done
    trunc_path+="$test_dir/"
    cur_path+="$directory/"
  done
  echo "${trunc_path: : -1}"
}

################################################################
# Dir: current working directory
# Parameters:
#   * $1 Alignment: string - left|right
#   * $2 Index: integer
set_default POWERLEVEL9K_DIR_PATH_SEPARATOR "/"
set_default POWERLEVEL9K_HOME_FOLDER_ABBREVIATION "~"
set_default POWERLEVEL9K_DIR_PATH_HIGHLIGHT_BOLD false
prompt_dot_dir_ex() {
  # using $PWD instead of "$(print -P '%~')" to allow use of POWERLEVEL9K_DIR_PATH_ABSOLUTE
  local current_path=$PWD # WAS: local current_path="$(print -P '%~')"
  # check if the user wants to use absolute paths or "~" paths
  [[ ${(L)POWERLEVEL9K_DIR_PATH_ABSOLUTE} != "true" ]] && current_path=${current_path//$HOME/"~"}
  # declare all local variables
  local paths directory test_dir test_dir_length trunc_path threshhold
  # if we are not in "~" or "/", split the paths into an array and exclude "~"
  (( ${#current_path} > 1 )) && paths=(${(s:/:)${current_path//"~\/"/}}) || paths=()
  # only run the code if SHORTEN_DIR_LENGTH is set, or we are using the two strategies that don't rely on it.
  if [[ -n "$POWERLEVEL9K_SHORTEN_DIR_LENGTH" || "$POWERLEVEL9K_SHORTEN_STRATEGY" == "truncate_with_folder_marker" || "$POWERLEVEL9K_SHORTEN_STRATEGY" == "truncate_to_last" || "$POWERLEVEL9K_SHORTEN_STRATEGY" == "truncate_with_package_name" ]]; then
    set_default POWERLEVEL9K_SHORTEN_DELIMITER "\u2026"
    # convert delimiter from unicode to literal character, so that we can get the correct length later
    local delim=$(echo -n $POWERLEVEL9K_SHORTEN_DELIMITER)

    case "$POWERLEVEL9K_SHORTEN_STRATEGY" in
      truncate_absolute_chars)
        if [ ${#current_path} -gt $(( $POWERLEVEL9K_SHORTEN_DIR_LENGTH + ${#POWERLEVEL9K_SHORTEN_DELIMITER} )) ]; then
          current_path=$POWERLEVEL9K_SHORTEN_DELIMITER${current_path:(-POWERLEVEL9K_SHORTEN_DIR_LENGTH)}
        fi
      ;;
      truncate_middle)
        # truncate characters from the middle of the path
        current_path=$(truncatePath $current_path $POWERLEVEL9K_SHORTEN_DIR_LENGTH $POWERLEVEL9K_SHORTEN_DELIMITER "middle")
      ;;
      truncate_from_right)
        # truncate characters from the right of the path
        current_path=$(truncatePath "$current_path" $POWERLEVEL9K_SHORTEN_DIR_LENGTH $POWERLEVEL9K_SHORTEN_DELIMITER)
      ;;
      truncate_absolute)
        # truncate all characters except the last POWERLEVEL9K_SHORTEN_DIR_LENGTH characters
        if [ ${#current_path} -gt $(( $POWERLEVEL9K_SHORTEN_DIR_LENGTH + ${#POWERLEVEL9K_SHORTEN_DELIMITER} )) ]; then
          current_path=$POWERLEVEL9K_SHORTEN_DELIMITER${current_path:(-POWERLEVEL9K_SHORTEN_DIR_LENGTH)}
        fi
      ;;
      truncate_to_last)
        # truncate all characters before the current directory
        current_path=${current_path##*/}
      ;;
      truncate_to_first_and_last)
        if (( ${#current_path} > 1 )) && (( ${POWERLEVEL9K_SHORTEN_DIR_LENGTH} > 0 )); then
          threshhold=$(( ${POWERLEVEL9K_SHORTEN_DIR_LENGTH} * 2))
          # if we are in "~", add it back into the paths array
          [[ $current_path == '~'* ]] && paths=("~" "${paths[@]}")
          if (( ${#paths} > $threshhold )); then
            local num=$(( ${#paths} - ${POWERLEVEL9K_SHORTEN_DIR_LENGTH} ))
            # repace the middle elements
            for (( i=$POWERLEVEL9K_SHORTEN_DIR_LENGTH; i<$num; i++ )); do
              paths[$i+1]=$POWERLEVEL9K_SHORTEN_DELIMITER
            done
            [[ $current_path != '~'* ]] && current_path="/" || current_path=""
            current_path+="${(j:/:)paths}"
          fi
        fi
      ;;
      truncate_to_unique)
        # for each parent path component find the shortest unique beginning
        # characters sequence. Source: https://stackoverflow.com/a/45336078
        if (( ${#current_path} > 1 )); then # root and home are exceptions and won't have paths
          # cheating here to retain ~ as home folder
          local home_path="$(getUniqueFolder $HOME)"
          trunc_path="$(getUniqueFolder $PWD)"
          [[ $current_path == "~"* ]] && current_path="~${trunc_path//${home_path}/}" || current_path="/${trunc_path}"
        fi
      ;;
      truncate_with_folder_marker)
        if (( ${#paths} > 0 )); then # root and home are exceptions and won't have paths, so skip this
          local last_marked_folder marked_folder
          set_default POWERLEVEL9K_SHORTEN_FOLDER_MARKER ".shorten_folder_marker"

          # Search for the folder marker in the parent directories and
          # buildup a pattern that is removed from the current path
          # later on.
          for marked_folder in $(upsearch $POWERLEVEL9K_SHORTEN_FOLDER_MARKER); do
            if [[ "$marked_folder" == "/" ]]; then
              # If we reached root folder, stop upsearch.
              trunc_path="/"
            elif [[ "$marked_folder" == "$HOME" ]]; then
              # If we reached home folder, stop upsearch.
              trunc_path="~"
            elif [[ "${marked_folder%/*}" == $last_marked_folder ]]; then
              trunc_path="${trunc_path%/}/${marked_folder##*/}"
            else
              trunc_path="${trunc_path%/}/$POWERLEVEL9K_SHORTEN_DELIMITER/${marked_folder##*/}"
            fi
            last_marked_folder=$marked_folder
          done

          # Replace the shortest possible match of the marked folder from
          # the current path.
          current_path=$trunc_path${current_path#${last_marked_folder}*}
        fi
      ;;
      truncate_with_package_name)
        local name repo_path package_path current_dir zero

        # Get the path of the Git repo, which should have the package.json file
        if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == "true" ]]; then
          # Get path from the root of the git repository to the current dir
          local gitPath=$(git rev-parse --show-prefix)
          # Remove trailing slash from git path, so that we can
          # remove that git path from the pwd.
          gitPath=${gitPath%/}
          package_path=${$(pwd)%%$gitPath}
          # Remove trailing slash
          package_path=${package_path%/}
        elif [[ $(git rev-parse --is-inside-git-dir 2> /dev/null) == "true" ]]; then
          package_path=${$(pwd)%%/.git*}
        fi

        # Replace the shortest possible match of the marked folder from
        # the current path. Remove the amount of characters up to the
        # folder marker from the left. Count only the visible characters
        # in the path (this is done by the "zero" pattern; see
        # http://stackoverflow.com/a/40855342/5586433).
        local zero='%([BSUbfksu]|([FB]|){*})'
        trunc_path=$(pwd)
        # Then, find the length of the package_path string, and save the
        # subdirectory path as a substring of the current directory's path from 0
        # to the length of the package path's string
        subdirectory_path=$(truncatePath "${trunc_path:${#${(S%%)package_path//$~zero/}}}" $POWERLEVEL9K_SHORTEN_DIR_LENGTH $POWERLEVEL9K_SHORTEN_DELIMITER)
        # Parse the 'name' from the package.json; if there are any problems, just
        # print the file path
        defined POWERLEVEL9K_DIR_PACKAGE_FILES || POWERLEVEL9K_DIR_PACKAGE_FILES=(package.json composer.json)

        local pkgFile="unknown"
        for file in "${POWERLEVEL9K_DIR_PACKAGE_FILES[@]}"; do
          if [[ -f "${package_path}/${file}" ]]; then
            pkgFile="${package_path}/${file}"
            break;
          fi
        done

        local packageName=$(jq '.name' ${pkgFile} 2> /dev/null \
          || node -e 'console.log(require(process.argv[1]).name);' ${pkgFile} 2>/dev/null \
          || cat "${pkgFile}" 2> /dev/null | grep -m 1 "\"name\"" | awk -F ':' '{print $2}' | awk -F '"' '{print $2}' 2>/dev/null \
          )
        if [[ -n "${packageName}" ]]; then
          # Instead of printing out the full path, print out the name of the package
          # from the package.json and append the current subdirectory
          current_path="`echo $packageName | tr -d '"'`$subdirectory_path"
        fi
      ;;
      *)
        if [[ $current_path != "~" ]]; then
          current_path="$(print -P "%$((POWERLEVEL9K_SHORTEN_DIR_LENGTH+1))(c:$POWERLEVEL9K_SHORTEN_DELIMITER/:)%${POWERLEVEL9K_SHORTEN_DIR_LENGTH}c")"
        fi
      ;;
    esac
  fi

  # save state of path for highlighting and bold options
  local path_opt=$current_path

  typeset -AH dir_states
  dir_states=(
    "DEFAULT"         "FOLDER_ICON"
    "HOME"            "HOME_ICON"
    "HOME_SUBFOLDER"  "HOME_SUB_ICON"
    "NOT_WRITABLE"    "LOCK_ICON"
    "ETC"             "ETC_ICON"
  )
  local state_path="$(print -P '%~')"
  local current_state="DEFAULT"
  if [[ $state_path == '/etc'* ]]; then
    current_state='ETC'
  elif [[ "${POWERLEVEL9K_DIR_SHOW_WRITABLE}" == true && ! -w "$PWD" ]]; then
    current_state="NOT_WRITABLE"
  elif [[ $state_path == '~' ]]; then
    current_state="HOME"
  elif [[ $state_path == '~'* ]]; then
    current_state="HOME_SUBFOLDER"
  fi

  # declare variables used for bold and state colors
  local bld_on bld_off dir_state_foreground dir_state_user_foreground
  # test if user wants the last directory printed in bold
  if [[ "${(L)POWERLEVEL9K_DIR_PATH_HIGHLIGHT_BOLD}" == "true" ]]; then
    bld_on="%B"
    bld_off="%b"
  else
    bld_on=""
    bld_off=""
  fi
  # determine is the user has set a last directory color
  local dir_state_user_foreground=POWERLEVEL9K_DIR_${current_state}_FOREGROUND
  local dir_state_foreground=${(P)dir_state_user_foreground}
  [[ -z ${dir_state_foreground} ]] && dir_state_foreground="${DEFAULT_COLOR}"

  local dir_name base_name
  # use ZSH substitution to get the dirname and basename instead of calling external functions
  dir_name=${path_opt%/*}
  base_name=${path_opt##*/}

  # if the user wants the last directory colored...
  if [[ -n ${POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND} ]]; then
    # it the path is "/" or "~"
    if [[ $path_opt == "/" || $path_opt == "~" ]]; then
      current_path="${bld_on}%F{$POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND}${current_path}${bld_off}"
    else # has a subfolder
      # test if dirname != basename - they are equal if we use truncate_to_last or truncate_absolute
      if [[ $dir_name != $base_name ]]; then
        current_path="${dir_name}/${bld_on}%F{$POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND}${base_name}${bld_off}"
      else
        current_path="${bld_on}%F{$POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND}${base_name}${bld_off}"
      fi
    fi
  else # no coloring
    # it the path is "/" or "~"
    if [[ $path_opt == "/" || $path_opt == "~" ]]; then
      current_path="${bld_on}${current_path}${bld_off}"
    else # has a subfolder
      # test if dirname != basename - they are equal if we use truncate_to_last or truncate_absolute
      if [[ $dir_name != $base_name ]]; then
        current_path="${dir_name}/${bld_on}${base_name}${bld_off}"
      else
        current_path="${bld_on}${base_name}${bld_off}"
      fi
    fi
  fi

  # check if we need to omit the first character and only do it if we are not in "~" or "/"
  if [[ "${POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER}" == "true" && $path_opt != "/" && $path_opt != "~" ]]; then
    current_path="${current_path[2,-1]}"
  fi

  # check if the user wants the separator colored.
  if [[ -n ${POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND} && $path_opt != "/" ]]; then
    # because this contains color changing codes, it is easier to set a variable for what should be replaced
    local repl="%F{$POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND}/%F{$dir_state_foreground}"
    # escape the / with a \
    current_path=${current_path//\//$repl}
  fi

  if [[ "${POWERLEVEL9K_DIR_PATH_SEPARATOR}" != "/" && $path_opt != "/" ]]; then
    current_path=${current_path//\//$POWERLEVEL9K_DIR_PATH_SEPARATOR}
  fi

  if [[ "${POWERLEVEL9K_HOME_FOLDER_ABBREVIATION}" != "~" && ! "${(L)POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER}" == "true" ]]; then
    # use :s to only replace the first occurance
    current_path=${current_path:s/~/$POWERLEVEL9K_HOME_FOLDER_ABBREVIATION}
  fi

  "$1_prompt_segment" "$0_${current_state}" "$2" "none" "cyan" "${current_path}%{$fg[yellow]%}]" "${dir_states[$current_state]}"
}

################################################################
# GO prompt
prompt_go_version() {
  local go_version
  local go_path
  go_version=$(go version 2>/dev/null | sed -E "s/.*(go[0-9.]*).*/\1/")
  go_path=$(go env GOPATH 2>/dev/null)

  if [[ -n "$go_version" && "${PWD##$go_path}" != "$PWD" ]]; then
    "$1_prompt_segment" "$0" "$2" "green" "grey93" "$go_version" "GO_ICON"
  fi
}

################################################################
# Test icons
prompt_icons_test() {
  for key in ${(@k)icons}; do
    # The lower color spectrum in ZSH makes big steps. Choosing
    # the next color has enough contrast to read.
    local random_color=$((RANDOM % 8))
    local next_color=$((random_color+1))
    "$1_prompt_segment" "$0" "$2" "$random_color" "$next_color" "$key" "$key"
  done
}

################################################################
# Segment to display the current IP address
prompt_ip() {
  if [[ "$OS" == "OSX" ]]; then
    if defined POWERLEVEL9K_IP_INTERFACE; then
      # Get the IP address of the specified interface.
      ip=$(ipconfig getifaddr "$POWERLEVEL9K_IP_INTERFACE")
    else
      local interfaces callback
      # Get network interface names ordered by service precedence.
      interfaces=$(networksetup -listnetworkserviceorder | grep -o "Device:\s*[a-z0-9]*" | grep -o -E '[a-z0-9]*$')
      callback='ipconfig getifaddr $item'

      ip=$(getRelevantItem "$interfaces" "$callback")
    fi
  else
    if defined POWERLEVEL9K_IP_INTERFACE; then
      # Get the IP address of the specified interface.
      ip=$(ip -4 a show "$POWERLEVEL9K_IP_INTERFACE" | grep -o "inet\s*[0-9.]*" | grep -o -E "[0-9.]+")
    else
      local interfaces callback
      # Get all network interface names that are up
      interfaces=$(ip link ls up | grep -o -E ":\s+[a-z0-9]+:" | grep -v "lo" | grep -o -E "[a-z0-9]+")
      callback='ip -4 a show $item | grep -o "inet\s*[0-9.]*" | grep -o -E "[0-9.]+"'

      ip=$(getRelevantItem "$interfaces" "$callback")
    fi
  fi

  if [[ -n "$ip" ]]; then
    "$1_prompt_segment" "$0" "$2" "cyan" "$DEFAULT_COLOR" "$ip" 'NETWORK_ICON'
  fi
}

################################################################
# Segment to display if VPN is active
set_default POWERLEVEL9K_VPN_IP_INTERFACE "tun"
# prompt if vpn active
prompt_vpn_ip() {
  for vpn_iface in $(/sbin/ifconfig | grep -e "^${POWERLEVEL9K_VPN_IP_INTERFACE}" | cut -d":" -f1)
  do
    ip=$(/sbin/ifconfig "$vpn_iface" | grep -o "inet\s.*" | cut -d' ' -f2)
    "$1_prompt_segment" "$0" "$2" "cyan" "$DEFAULT_COLOR" "$ip" 'VPN_ICON'
  done
}


################################################################
# Segment to diplay Node version
prompt_node_version() {
  local node_version=$(node -v 2>/dev/null)
  [[ -z "${node_version}" ]] && return

  "$1_prompt_segment" "$0" "$2" "green" "white" "${node_version:1}" 'NODE_ICON'
}

################################################################
# Segment to display Node version from NVM
# Only prints the segment if different than the default value
prompt_nvm() {
  local node_version nvm_default
  (( $+functions[nvm_version] )) || return

  node_version=$(nvm_version current)
  [[ -z "${node_version}" || ${node_version} == "none" ]] && return

  nvm_default=$(nvm_version default)
  [[ "$node_version" =~ "$nvm_default" ]] && return

  $1_prompt_segment "$0" "$2" "magenta" "black" "${node_version:1}" 'NODE_ICON'
}


################################################################
# Segment to display rbenv information
# https://github.com/rbenv/rbenv#choosing-the-ruby-version
set_default POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW false
prompt_rbenv() {
  if [[ -n "$RBENV_VERSION" ]]; then
    "$1_prompt_segment" "$0" "$2" "red" "$DEFAULT_COLOR" "$RBENV_VERSION" 'RUBY_ICON'
  elif [ $commands[rbenv] ]; then
    local rbenv_version_name="$(rbenv version-name)"
    local rbenv_global="$(rbenv global)"
    if [[ "${rbenv_version_name}" != "${rbenv_global}" || "${POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW}" == "true" ]]; then
      "$1_prompt_segment" "$0" "$2" "red" "$DEFAULT_COLOR" "$rbenv_version_name" 'RUBY_ICON'
    fi
  fi
}

################################################################
# Segment to display chruby information
# see https://github.com/postmodern/chruby/issues/245 for chruby_auto issue with ZSH
prompt_chruby() {
  # Uses $RUBY_VERSION and $RUBY_ENGINE set by chruby
  set_default POWERLEVEL9K_CHRUBY_SHOW_VERSION true
  set_default POWERLEVEL9K_CHRUBY_SHOW_ENGINE true
  local chruby_label=""

  if [[ "$POWERLEVEL9K_CHRUBY_SHOW_ENGINE" == true ]]; then
    chruby_label+="$RUBY_ENGINE "
  fi
  if [[ "$POWERLEVEL9K_CHRUBY_SHOW_VERSION" == true ]]; then
    chruby_label+="$RUBY_VERSION"
  fi

  # Truncate trailing spaces
  chruby_label="${chruby_label%"${chruby_label##*[![:space:]]}"}"

  # Don't show anything if the chruby did not change the default ruby
  if [[ "$RUBY_ENGINE" != "" ]]; then
    "$1_prompt_segment" "$0" "$2" "red" "$DEFAULT_COLOR" "${chruby_label}" 'RUBY_ICON'
  fi
}

################################################################
# Segment to display SSH icon when connected
prompt_ssh() {
  if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    "$1_prompt_segment" "$0" "$2" "$DEFAULT_COLOR" "yellow" "" 'SSH_ICON'
  fi
}

################################################################
# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n "$virtualenv_path" && -z "$VIRTUAL_ENV_DISABLE_PROMPT" ]]; then
    "$1_prompt_segment" "$0" "$2" "blue" "$DEFAULT_COLOR" "$(basename "$virtualenv_path")" 'PYTHON_ICON'
  fi
}

################################################################
# Kubernetes Current Context/Namespace
prompt_kubecontext() {
  local kubectl_version="$(kubectl version --client 2>/dev/null)"

  if [[ -n "$kubectl_version" ]]; then
    # Get the current Kuberenetes context
    local cur_ctx=$(kubectl config view -o=jsonpath='{.current-context}')
    cur_namespace="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${cur_ctx}\")].context.namespace}")"
    # If the namespace comes back empty set it default.
    if [[ -z "${cur_namespace}" ]]; then
      cur_namespace="default"
    fi

    local k8s_final_text=""

    if [[ "$cur_ctx" == "$cur_namespace" ]]; then
      # No reason to print out the same identificator twice
      k8s_final_text="$cur_ctx"
    else
      k8s_final_text="$cur_ctx/$cur_namespace"
    fi

    "$1_prompt_segment" "$0" "$2" "magenta" "white" "$k8s_final_text" "KUBERNETES_ICON"
  fi
}

# print Java version number
prompt_java_version() {
  local java_version
  # Stupid: Java prints its version on STDERR.
  # The first version ouput will print nothing, we just
  # use it to transport whether the command was successful.
  # If yes, we parse the version string (and need to
  # redirect the stderr to stdout to make the pipe work).
  java_version=$(java -version 2>/dev/null && java -fullversion 2>&1 | cut -d '"' -f 2)

  if [[ -n "$java_version" ]]; then
    "$1_prompt_segment" "$0" "$2" "red" "white" "$java_version" "JAVA_ICON"
  fi
}
