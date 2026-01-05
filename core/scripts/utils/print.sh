#!/bin/sh

# Gruvbox Color
GREEN="#b8bb26"
RED="#fb4934"
BG_DARK="#282828"

print_ok() {
  gum style \
    --foreground "$GREEN" \
    --bold \
    "OK"
}

print_failed() {
  gum style \
    --foreground "$RED" \
    --bold \
    "FAILED"
}
