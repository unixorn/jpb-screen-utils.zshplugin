#!/usr/bin/env zsh

show-screens() {
  # deal with screen, if we're using it - courtesy MacOSXHints.com
  # Login greeting ------------------
  if [[ "$TERM" = "screen" && ! "$SHOWED_SCREEN_MESSAGE" = "true" ]]; then
    detached_screens=$(screen -list | grep Detached)
    if [[ ! -z "$detached_screens" ]]; then
      echo "+---------------------------------------+"
      echo "| Detached screens are available:       |"
      echo "$detached_screens"
      echo "+---------------------------------------+"
    fi
    unset detached_screens
  fi
}

reattach-or-list() {
  # Check for a detached screen session and reconnect. If there are more than
  # one, list them instead.
  #
  # Based on http://ptone.com/dablog/2009/02/getting-the-screen-religion/
  AM_I_REMOTE=$(who am i | grep -c ")$")
  if [[ $AM_I_REMOTE -gt 0 ]]; then
    SCREENS=$(screen -list | head -1 | awk '{ print $1 }')
    if [[ $SCREENS = 'No' ]]; then
      screen -t Main
    else
      SCREENCOUNT=$(screen -list | tail -2 | head -1 | awk '{ print $1 }')
      if [[ $SCREENCOUNT -eq 1 ]]; then
        screen -r
      else
        CANDIDATE_SCREEN=$(screen -list | grep "(Detached)" | head -1 | awk -F "." '{print $1}')
        DETACHED_SCREENCOUNT=$(screen -list | grep -c "(Detached)")
        if [[ $DETACHED_SCREENCOUNT -gt 0 ]];then
          screen -R "$CANDIDATE_SCREEN"
        fi
      fi
    fi
  fi
  unset AM_I_REMOTE
  unset CANDIDATE_SCREEN
  unset DETACHED_SCREENCOUNT
  unset SCREENCOUNT
  unset SCREENS
}
