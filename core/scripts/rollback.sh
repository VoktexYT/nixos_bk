#!/bin/sh

exec_rollback() {
  sudo -v
  [ "$1" == "clear" ] && clear

  export COLORTERM=truecolor

  GENERATIONS=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system)

  ID=$(echo "$GENERATIONS" | gum choose \
      --cursor="" \
      --header="Select the generation to restore:" \
      --header.foreground="#fabd2f" \
      --selected.foreground="#83a598" \
      --selected.bold \
      --item.foreground="#83a598" | awk '{print $1}')

  [ -z "$ID" ] && echo -e "\033[0;31mOperation cancelled.\033[0m" && exit 0

  if ! gum confirm \
      --prompt.foreground="#ebdbb2" \
      --selected.background="#fe8019" \
      --selected.foreground="#282828" \
      --unselected.background="#3c3836" \
      --unselected.foreground="#a89984" \
      --affirmative "Restore" \
      --negative "Cancel" \
      "Are you sure you want to restore generation $ID?"; then
  
    echo -e "\n\033[0;33mOperation cancelled\033[0m"
    return 0
  fi

  run_step "Symlink Management..." "sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation $ID"
  run_step "System Rollback..." "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch"
  print_ok
}
