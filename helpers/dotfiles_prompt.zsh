# vim:ft=zsh ts=2 sw=2 sts=2 et fenc=utf-8

# # Turn on for Debugging
# PS4='%s%f%b%k%F{blue}%{λ%}%L %F{240}%N:%i%(?.. %F{red}%?) %1(_.%F{yellow}%-1_ .)%s%f%b%k '
# zstyle ':vcs_info:*+*:*' debug true
# set -o xtrace

source "${HOME}/dotfiles/helpers/colors.zsh"

source "${HOME}/dotfiles/helpers/icons.zsh"

source "${HOME}/dotfiles/helpers/utilities.zsh"

DEFAULT_COLOR=white
DEFAULT_COLOR_INVERTED=black


function snpt() {
  local icon_name=$1
  local color=""
  if [[ ! -z $2 ]]; then
    local color="%{$fg[$2]%}"
  fi
  local ICON_USER_VARIABLE=POWERLEVEL9K_${icon_name}
  if defined "$ICON_USER_VARIABLE"; then
    echo -n "${color}${(P)ICON_USER_VARIABLE}"
  else
    echo -n "${color}${icons[$icon_name]}"
  fi
}



################################################################
# Prompt Segment Constructors
#
# Methodology behind user-defined variables overwriting colors:
#     The first parameter to the segment constructors is the calling function's
#     name. From this function name, we strip the "prompt_"-prefix and
#     uppercase it. This is then prefixed with "POWERLEVEL9K_" and suffixed
#     with either "_BACKGROUND" or "_FOREGROUND", thus giving us the variable
#     name. So each new segment is user-overwritten by a variable following
#     this naming convention.
################################################################

# The `CURRENT_BG` variable is used to remember what the last BG color used was
# when building the left-hand prompt. Because the RPROMPT is created from
# right-left but reads the opposite, this isn't necessary for the other side.
CURRENT_BG='NONE'

# Begin a left prompt segment
# Takes four arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
# The latter three can be omitted,
set_default last_left_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS " "

left_prompt_segment() {
  local segment_name="${1}"
  local current_index=$2
  # Check if the segment should be joined with the previous one
  local joined
  segmentShouldBeJoined $current_index $last_left_element_index "$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS" && joined=true || joined=false
  # Colors
  local backgroundColor="${3}"
  local foregroundColor="${4}"

  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)${segment_name}#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && backgroundColor="$BG_COLOR_MODIFIER"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)${segment_name}#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && foregroundColor="$FG_COLOR_MODIFIER"

  # Get color codes here to save some calls later on
  backgroundColor="$(getColorCode ${backgroundColor})"
  foregroundColor="$(getColorCode ${foregroundColor})"

  local background foreground
  [[ -n "${backgroundColor}" ]] && background="$(backgroundColor ${backgroundColor})" || background="%k"
  [[ -n "${foregroundColor}" ]] && foreground="$(foregroundColor ${foregroundColor})" || foreground="%f"

  if [[ $CURRENT_BG != 'NONE' ]] && ! isSameColor "${backgroundColor}" "$CURRENT_BG"; then
    echo -n "${background}%F{$CURRENT_BG}"
    if [[ $joined == false ]]; then
      # Middle segment
      echo -n "$(print_icon 'LEFT_SEGMENT_SEPARATOR')$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
    fi
  elif isSameColor "$CURRENT_BG" "${backgroundColor}"; then
    # Middle segment with same color as previous segment
    # We take the current foreground color as color for our
    # subsegment (or the default color). This should have
    # enough contrast.
    local complement
    [[ -n "${foregroundColor}" ]] && complement="${foreground}" || complement="$(foregroundColor $DEFAULT_COLOR)"
    echo -n "${background}${complement}"
    if [[ $joined == false ]]; then
      echo -n "$(print_icon 'LEFT_SUBSEGMENT_SEPARATOR')$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
    fi
  else
    # First segment
    echo -n "${background}$POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS"
  fi

  local visual_identifier
  if [[ -n $6 ]]; then
    visual_identifier="$(print_icon $6)"
    if [[ -n "$visual_identifier" ]]; then
      # Add an whitespace if we print more than just the visual identifier.
      # To avoid cutting off the visual identifier in some terminal emulators (e.g., Konsole, st),
      # we need to color both the visual identifier and the whitespace.
      [[ -n "$5" ]] && visual_identifier="$visual_identifier "
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable=POWERLEVEL9K_${(U)${segment_name}#prompt_}_VISUAL_IDENTIFIER_COLOR
      set_default $visual_identifier_color_variable "${foregroundColor}"
      visual_identifier="$(foregroundColor ${(P)visual_identifier_color_variable})${visual_identifier}%f"
    fi
  fi

  # Print the visual identifier
  echo -n "${visual_identifier}"
  # Print the content of the segment, if there is any
  [[ -n "$5" ]] && echo -n "${foreground}${5}"
  echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS}"

  CURRENT_BG="${backgroundColor}"
  last_left_element_index=$current_index
}

# End the left prompt, closes the final segment.
left_prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%k$(foregroundColor ${CURRENT_BG})$(print_icon 'LEFT_SEGMENT_SEPARATOR')"
  else
    echo -n "%k"
  fi
  echo -n "%f$(print_icon 'LEFT_SEGMENT_END_SEPARATOR')"
  CURRENT_BG=''
}

CURRENT_RIGHT_BG='NONE'

# Begin a right prompt segment
# Takes four arguments:
#   * $1: Name of the function that was originally invoked (mandatory).
#         Necessary, to make the dynamic color-overwrite mechanism work.
#   * $2: The array index of the current segment
#   * $3: Background color
#   * $4: Foreground color
#   * $5: The segment content
#   * $6: An identifying icon (must be a key of the icons array)
# No ending for the right prompt segment is needed (unlike the left prompt, above).
set_default last_right_element_index 1
set_default POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS " "
right_prompt_segment() {
  local segment_name="${1}"
  local current_index=$2

  # Check if the segment should be joined with the previous one
  local joined
  segmentShouldBeJoined $current_index $last_right_element_index "$POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS" && joined=true || joined=false

  # Colors
  local backgroundColor="${3}"
  local foregroundColor="${4}"

  # Overwrite given background-color by user defined variable for this segment.
  local BACKGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)${segment_name}#prompt_}_BACKGROUND
  local BG_COLOR_MODIFIER=${(P)BACKGROUND_USER_VARIABLE}
  [[ -n $BG_COLOR_MODIFIER ]] && backgroundColor="$BG_COLOR_MODIFIER"

  # Overwrite given foreground-color by user defined variable for this segment.
  local FOREGROUND_USER_VARIABLE=POWERLEVEL9K_${(U)${segment_name}#prompt_}_FOREGROUND
  local FG_COLOR_MODIFIER=${(P)FOREGROUND_USER_VARIABLE}
  [[ -n $FG_COLOR_MODIFIER ]] && foregroundColor="$FG_COLOR_MODIFIER"

  # Get color codes here to save some calls later on
  backgroundColor="$(getColorCode ${backgroundColor})"
  foregroundColor="$(getColorCode ${foregroundColor})"

  local background foreground
  [[ -n "${backgroundColor}" ]] && background="$(backgroundColor ${backgroundColor})" || background="%k"
  [[ -n "${foregroundColor}" ]] && foreground="$(foregroundColor ${foregroundColor})" || foreground="%f"

  # If CURRENT_RIGHT_BG is "NONE", we are the first right segment.

  if [[ "$CURRENT_RIGHT_BG" != "NONE" ]]; then
    # This is the closing whitespace for the previous segment
    echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}%f"
  fi

  if [[ $joined == false ]] || [[ "$CURRENT_RIGHT_BG" == "NONE" ]]; then
    if isSameColor "$CURRENT_RIGHT_BG" "${backgroundColor}"; then
      # Middle segment with same color as previous segment
      # We take the current foreground color as color for our
      # subsegment (or the default color). This should have
      # enough contrast.
      local complement
      [[ -n "${foregroundColor}" ]] && complement="${foreground}" || complement="$(foregroundColor $DEFAULT_COLOR)"
      echo -n "$complement$(print_icon 'RIGHT_SUBSEGMENT_SEPARATOR')%f"
    else
      # Use the new Background Color as the foreground of the segment separator
      echo -n "$(foregroundColor ${backgroundColor})$(print_icon 'RIGHT_SEGMENT_SEPARATOR')%f"
    fi
  fi

  local visual_identifier
  if [[ -n "$6" ]]; then
    visual_identifier="$(print_icon $6)"
    if [[ -n "$visual_identifier" ]]; then
      # Add an whitespace if we print more than just the visual identifier.
      # To avoid cutting off the visual identifier in some terminal emulators (e.g., Konsole, st),
      # we need to color both the visual identifier and the whitespace.
      [[ -n "$5" ]] && visual_identifier=" $visual_identifier"
      # Allow users to overwrite the color for the visual identifier only.
      local visual_identifier_color_variable=POWERLEVEL9K_${(U)${segment_name}#prompt_}_VISUAL_IDENTIFIER_COLOR
      set_default $visual_identifier_color_variable "${foregroundColor}"
      visual_identifier="$(foregroundColor ${(P)visual_identifier_color_variable})${visual_identifier}%f"
    fi
  fi

  echo -n "${background}${foreground}"

  # Print whitespace only if segment is not joined or first right segment
  [[ $joined == false ]] || [[ "$CURRENT_RIGHT_BG" == "NONE" ]] && echo -n "${POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS}"

  # Print segment content if there is any
  [[ -n "$5" ]] && echo -n "${5}"
  # Print the visual identifier
  echo -n "${visual_identifier}"

  CURRENT_RIGHT_BG="${backgroundColor}"
  last_right_element_index=$current_index
}

source "${HOME}/dotfiles/helpers/dotfiles_prompt_segments.zsh"


################################################################
# Prompt processing and drawing
################################################################
# Main prompt
build_left_prompt() {
  local index=1
  local element
  for element in "${POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[@]}"; do
    # Remove joined information in direct calls
    element=${element%_joined}

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "left" "$index" $element[8,-1]
    else
      "prompt_$element" "left" "$index"
    fi

    index=$((index + 1))
  done

  left_prompt_end
}

# Right prompt
build_right_prompt() {
  local index=1
  local element
  for element in "${POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[@]}"; do
    # Remove joined information in direct calls
    element=${element%_joined}

    # Check if it is a custom command, otherwise interpet it as
    # a prompt.
    if [[ $element[0,7] =~ "custom_" ]]; then
      "prompt_custom" "right" "$index" $element[8,-1]
    else
      "prompt_$element" "right" "$index"
    fi

    index=$((index + 1))
  done

  # Clear to the end of the line
  echo -n "%E"
}

powerlevel9k_preexec() {
  _P9K_TIMER_START=$EPOCHREALTIME
}

set_default POWERLEVEL9K_PROMPT_ADD_NEWLINE false
powerlevel9k_prepare_prompts() {
  # Return values. These need to be global, because
  # they are used in prompt_status. Also, we need
  # to get the return value of the last command at
  # very first in this function. Do not move the
  # lines down, otherwise the last command is not
  # what you expected it to be.
  RETVAL=$?
  RETVALS=( "$pipestatus[@]" )

  local RPROMPT_SUFFIX RPROMPT_PREFIX
  _P9K_COMMAND_DURATION=$((EPOCHREALTIME - _P9K_TIMER_START))

  # Reset start time
  _P9K_TIMER_START=0x7FFFFFFF

local LC_ALL="" LC_CTYPE="en_US.UTF-8" # Set the right locale to protect special characters
RPROMPT_PREFIX='%{'$'\e[1A''%}' # one line up
RPROMPT_SUFFIX='%{'$'\e[1B''%}%{$reset_color%}' # one line down

RPROMPT="${RPROMPT_PREFIX}"'%f%b%k$(build_right_prompt)%{$reset_color%}'"${RPROMPT_SUFFIX}"
#RPROMPT="${RPROMPT_PREFIX}${RPROMPT_SUFFIX}"


ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}[%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg[yellow]%}] "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}⚡%{$reset_color%}"


PROMPT=$'$(snpt "DOTFILES_UL_START" "yellow")$(build_left_prompt)'
PS2=$'%{$fg[green]%}|>%{$reset_color%}'
}

zle-keymap-select () {
	zle reset-prompt
	zle -R
}

set_default POWERLEVEL9K_IGNORE_TERM_COLORS false
set_default POWERLEVEL9K_IGNORE_TERM_LANG false

prompt_powerlevel9k_setup() {
  # The value below was set to better support 32-bit CPUs.
  # It's the maximum _signed_ integer value on 32-bit CPUs.
  # Please don't change it until 19 January of 2038. ;)

  # Disable false display of command execution time
  _P9K_TIMER_START=0x7FFFFFFF

  # The prompt function will set these prompt_* options after the setup function
  # returns. We need prompt_subst so we can safely run commands in the prompt
  # without them being double expanded and we need prompt_percent to expand the
  # common percent escape sequences.
  prompt_opts=(cr percent sp subst)

  # Borrowed from promptinit, sets the prompt options in case the theme was
  # not initialized via promptinit.
  setopt noprompt{bang,cr,percent,sp,subst} "prompt${^prompt_opts[@]}"

  defined POWERLEVEL9K_LEFT_PROMPT_ELEMENTS || POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
  defined POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS || POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv)

  # initialize colors
  autoload -U colors && colors

  # initialize timing functions
  zmodload zsh/datetime

  # Initialize math functions
  zmodload zsh/mathfunc

  # initialize hooks
  autoload -Uz add-zsh-hook

  # prepare prompts
  add-zsh-hook precmd powerlevel9k_prepare_prompts
  add-zsh-hook preexec powerlevel9k_preexec

  zle -N zle-keymap-select
}

prompt_powerlevel9k_teardown() {
  add-zsh-hook -D precmd powerlevel9k_\*
  add-zsh-hook -D preexec powerlevel9k_\*
  PROMPT='%m%# '
  RPROMPT=
}

prompt_powerlevel9k_setup "$@"
