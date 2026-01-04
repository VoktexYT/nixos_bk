BG_ORANGE="#FE8019"
FG_DARK="#282828"
GRAY="#928374"
TEXT_LIGHT="#EBDBB2"

loading_exec() {
    local title="$1"
    local cmd="$2"
    local persist="$3"

    local color_title="\033[38;2;211;134;155m" 
    local color_done="\033[0;32m"              
    local color_reset="\033[0m"

    if [ "$persist" = "show" ]; then
        echo -ne "${color_title}$title${color_reset}"

        gum spin \
            --spinner dot \
            --spinner.foreground="#FE8019" \
            --title "$title" \
            --title.foreground="#d3869b" -- \
            bash -c "$cmd"

        echo -e "\r${color_title}$title ${color_done}(DONE)${color_reset}"
    else
        gum spin \
            --spinner dot \
            --spinner.foreground="#FE8019" \
            --title "$title" \
            --title.foreground="#d3869b" -- \
            bash -c "$cmd"
    fi
}

case "$1" in
rebuild)
    sudo -v

    LOG=$(mktemp)

    loading_exec "Rebuild system..." "sudo nixos-rebuild switch --flake /persist/etc/nixos#voktex > /dev/null 2> $LOG"

    if [ $? -eq 0 ]; then
        echo -e "\033[0;32mOK\033[0m"
        rm "$LOG"
    else
        echo -e "\033[0;31mERROR :\033[0m"
        cat "$LOG" | gum format -t code --language bash
        rm "$LOG"
        exit 1
    fi
    ;;

refresh-desktop)
    loading_exec "Kill waybar process..." "pkill waybar" "show"
    loading_exec "Create waybar process..." "hyprctl dispatch exec waybar" "show"
    loading_exec "Reload Hyprland..." "hyprctl reload" "show"

    if [ $? -eq 0 ]; then
        echo -e "\033[0;32mOK\033[0m"
    fi
    ;;

hard-clean)
    if gum confirm \
        --prompt.foreground="$BEIGE_GRUV" \
        --selected.background="$BG_ORANGE" \
        --selected.foreground="$FG_DARK" \
        --unselected.background="$FG_DARK" \
        --unselected.foreground="$GRAY" \
        --affirmative "Yes" \
        --negative "No" \
        "This will delete all previous system generations. Are you sure?"; then
        sudo -v
        loading_exec "Cleaning user generations..." "nix-env --delete-generations old" "show"
        loading_exec "Cleaning system generations and running garbage collector..." "sudo nix-collect-garbage -d" "show"
        loading_exec "Updating boot menu..." "sudo /run/current-system/bin/switch-to-configuration boot" "show"
        loading_exec "Optimizing the nix store..." "nix-store --optimise" "show"

        if [ $? -eq 0 ]; then
            echo -e "\033[0;32mOK\033[0m"
        fi
    else
        echo "Operation cancelled."
        exit 0
    fi
    ;;

try)
    nix-shell -p $2
    ;;

watch)
    if [ -n "$2" ]; then
        QUERY="$2"
    else
        QUERY=$(gum input --placeholder "Search on YouTube..." \
            --width 50 \
            --prompt.foreground "#ebdbb2" \
            --cursor.foreground "#fe8019")
    fi

    if [ -n "$QUERY" ]; then
        ytfzf -t --video-pref="480p" "$QUERY"
    else
        echo -e "\033[0;31mSearch cancelled.\033[0m"
    fi
    ;;

code)
    zellij delete-all-sessions -y 
    zellij --layout dev
    ;;

help)
    echo "kanso <args>"
    echo "- rebuild"
    echo "- refresh-desktop"
    echo "- hard-clean"
    echo "- try <string = package name>"
    echo "- watch <string = YouTube search keyword>"
    ;;
*)
    echo -e "\033[0;31mINVALID KANSO ARGUMENT '$1'\nWrite 'kanso help' for more\033[0m"
    ;;
esac
