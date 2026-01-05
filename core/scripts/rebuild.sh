#!/bin/sh

exec_rebuild() {
  sudo -v
  [ "$1" == "clear" ] && clear

  LOG=$(mktemp)
  
  loading_exec \
    "Rebuild system..." \
    "sudo nixos-rebuild switch --flake /vault/etc/nixos#voktex --impure > /dev/null 2> $LOG"

  if [ $? -eq 0 ]; then
    print_ok
    rm "$LOG"
  else
    print_failed
    cat "$LOG" | gum format -t code --language bash
    rm "$LOG"
    exit 1
  fi
}
