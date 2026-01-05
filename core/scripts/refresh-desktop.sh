#!/bin/sh

exec_refresh_desktop() {
  run_step "Stopping Waybar..." "pkill waybar"
  run_step "Starting Waybar..." "hyprctl dispatch exec waybar"
  run_step "Reloading Hyprland..." "hyprctl reload"
  print_ok
}
