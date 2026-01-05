#!/usr/bin/env python3
import sys
import subprocess
from core import ops

def show_help():
    print("""
Kanso CLI - System Management (Python Core)

Usage: kanso <command> [arguments]

Commands:
  snapshot [name]  Create config snapshot (or 'class::clear' for interactive)
  rebuild          Rebuild system configuration
  refresh-desktop  Restart Waybar and reload Hyprland
  hard-clean       Deep clean Nix generations and Git history
  watch-youtube    Search and play YouTube videos
  rewind           Interactive Git restore for /vault
  rollback         Restore previous NixOS generation
  code-editor      Launch Zellij development layout
""")

def main():
    if len(sys.argv) < 2:
        show_help()
        sys.exit(0)

    command = sys.argv[1]
    args = sys.argv[2:]

    clear_arg = "class::clear" in args
    arg_val = args[0] if args and args[0] != "class::clear" else None

    commands = {
        "snapshot":        lambda: ops.snapshot(clear_screen=clear_arg),
        "rebuild":         lambda: ops.rebuild(clear_screen=clear_arg),
        "rollback":        lambda: ops.rollback(clear_screen=clear_arg),
        "refresh-desktop": lambda: ops.refresh_desktop(),
        "hard-clean":      lambda: ops.hard_clean(clear_screen=clear_arg),
        "watch-youtube":   lambda: ops.watch_youtube(arg_val),
        "code-editor":     lambda: ops.code_editor(),
        "rewind":          lambda: ops.rewind(clear_screen=clear_arg),
        "help":            show_help,
    }

    if command in commands:
        commands[command]()
    else:
        subprocess.run(["gum", "style", "--foreground", "#fb4934", f"Error: Invalid command '{command}'"])
        sys.exit(1)
        
if __name__ == "__main__":
    main()
