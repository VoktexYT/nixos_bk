#!/bin/sh

exec_rewind() {
  sudo -v

  [ "$1" == "clear" ] && clear

  cd /vault || return 1

  HISTORY=$(git log --oneline --format="%h | %ad | %s" --date=short)

  SELECTED_VERSION=$(echo "$HISTORY" | gum choose \
    --cursor="" \
    --header="Select the configuration to restore:" \
    --header.foreground="#fabd2f" \
    --selected.foreground="#83a598" \
    --selected.bold \
    --height=20 \
    --item.foreground="#83a598")

  if [ -z "$SELECTED_VERSION" ]; then
    echo -e "\n\033[0;33mNo version selected. Operation cancelled.\033[0m"
    return 0
  fi

  local HASH=$(echo "$SELECTED_VERSION" | cut -d'|' -f1 | xargs)
  
  if ! gum confirm \
      --prompt.foreground="#ebdbb2" \
      --selected.background="#fe8019" \
      --selected.foreground="#282828" \
      --unselected.background="#3c3836" \
      --unselected.foreground="#a89984" \
      --affirmative "Restore" \
      --negative "Cancel" \
      "This will permanently discard all changes made after $HASH. Proceed?"; then
        
      echo -e "\n\033[0;33mOperation cancelled\033[0m"
      return 0
  fi

  run_step "Restoring configuration to $HASH..." "sudo git -C /vault reset --hard $HASH"
} 
