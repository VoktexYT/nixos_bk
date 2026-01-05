#!/bin/sh

exec_watch_youtube() {
  local QUERY="$1"
  
  if [ -z "$QUERY" ]; then
    QUERY=$(gum input \
            --placeholder "YouTube Search..." \
            --width 50 \
            --prompt.foreground "#ebdbb2" \
            --cursor.foreground "#fe8019")

    if [ -z "$QUERY" ]; then
      gum style --foreground "#fb4934" "Search cancelled."
      return 1
    fi
  fi

  clear
  ytfzf -t --video-pref="480p" "$QUERY"
}
