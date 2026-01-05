#!/bin/sh

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

. "$ROOT_DIR/scripts/utils/print.sh"
. "$ROOT_DIR/scripts/utils/loading_exec.sh"
. "$ROOT_DIR/scripts/snapshot.sh"
. "$ROOT_DIR/scripts/rebuild.sh"
. "$ROOT_DIR/scripts/rollback.sh"
. "$ROOT_DIR/scripts/refresh-desktop.sh"
. "$ROOT_DIR/scripts/hard-clean.sh"
. "$ROOT_DIR/scripts/rewind.sh"

. "$ROOT_DIR/apps/watch-youtube.sh"
. "$ROOT_DIR/apps/code-editor.sh"

export GUM_CHOOSE_CURSOR_FOREGROUND="#89b4fa"
export GUM_CHOOSE_HEADER_FOREGROUND="#D65D0E"

export BG_ORANGE="#FE8019"
export FG_DARK="#282828"
export GRAY="#928374"
export BEIGE_GRUV="#EBDBB2"

menu_choose() {
    gum choose \
        --cursor="" \
        --header="$1" \
        --selected.foreground="#83a598" \
        --selected.bold \
        --item.foreground="#ebdbb2" \
        "${@:2}"
}

if [ -z "$1" ]; then
    "$0" help
    exit 0
fi

COMMAND="$1"
shift

case "$COMMAND" in
    snapshot)        exec_snapshot "$@" ;;
    rebuild)         exec_rebuild "$@" ;;
    rollback)        exec_rollback "$@" ;;
    refresh-desktop) exec_refresh_desktop "$@" ;;
    hard-clean)      exec_hard_clean "$@" ;;
    watch-youtube)   exec_watch_youtube "$@" ;;
    code-editor)     exec_code_editor "$@" ;;
    rewind)          exec_rewind "$@" ;;
    
    help|--help|-h)
        echo "Kanso CLI - System Management"
        echo ""
        echo "Usage: kanso <command> [arguments]"
        echo ""
        echo "Commands:"
        echo "  snapshot         Create a config snapshot (accepts name or 'class::clear')"
        echo "  rebuild          Rebuild the system configuration"
        echo "  refresh-desktop  Restart Waybar and reload Hyprland"
        echo "  hard-clean       Deep clean Nix generations and Git history"
        echo "  watch-youtube    Search and play YouTube videos via ytfzf"
        echo "  rewind           Interactive Git restore for /vault"
        ;;

    *)
        gum style \
            --foreground "#fb4934" \
"Error: Invalid argument '$COMMAND'.
Type 'kanso help' for available commands."
        exit 1
        ;;
esac
