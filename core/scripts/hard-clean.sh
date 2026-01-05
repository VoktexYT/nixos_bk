#!/bin/sh

exec_hard_clean() {
  sudo -v
  [ "$1" == "clear" ] && clear

  if ! gum confirm \
      --prompt.foreground="$BEIGE_GRUV" \
      --selected.background="$BG_ORANGE" \
      --selected.foreground="$FG_DARK" \
      --unselected.background="$FG_DARK" \
      --unselected.foreground="$GRAY" \
      --affirmative "Yes" \
      --negative "No" \
      "This will delete all previous system generations and config snapshot. Are you sure?"; then

      echo "Operation cancelled."
      return 0
  fi

  run_step "Cleaning user generations..." "nix-env --delete-generations old"
  run_step "Cleaning system generations and running garbage collection..." "sudo nix-collect-garbage -d"
  run_step "Updating boot menu..." "sudo /run/current-system/bin/switch-to-configuration boot"
  run_step "Optimizing the Nix store..." "nix-store --optimise"
  run_step "Deleting snapshot history..." "sudo rm -rf /vault/.git"
  run_step "Initializing stable snapshot..." "sudo git -C /vault init"

  exec_snapshot "STABLE"
    
  print_ok
}
