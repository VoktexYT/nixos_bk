#!/bin/sh

exec_snapshot() {
  local SNAPSHOT_NAME="$1"
  
  sudo -v

  if [ "$SNAPSHOT_NAME" == "class::clear" ]; then
      clear
      SNAPSHOT_NAME=$(gum input --cursor.foreground "#FE8019" --placeholder "Name...")

      if [ -z "$SNAPSHOT_NAME" ]; then
        echo -e "Operation canceled..."
        return 0
      fi
    
      clear
  fi

  run_step "Creating configuration snapshot..." \
    "sudo git -C /vault add . && sudo git -C /vault -c user.name='root' -c user.email='root@kanso.local' commit -m \"$SNAPSHOT_NAME\""

  print_ok
}
