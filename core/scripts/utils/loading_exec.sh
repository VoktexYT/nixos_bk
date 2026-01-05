#!/bin/sh


loading_exec() {
    local title="$1"
    local cmd="$2"
    local persist="$3"

    # Gruvbox Colors
    local PURPLE="#d3869b"
    local ORANGE="#fe8019"
    local GREEN="#b8bb26"

    gum spin \
        --spinner dot \
        --spinner.foreground "$ORANGE" \
        --title "$title" \
        --title.foreground "$PURPLE" -- \
        bash -c "$cmd"
    
    local exit_code=$?

    if [ "$persist" = "show" ]; then
        if [ $exit_code -eq 0 ]; then
            echo -e "\r$(gum style --foreground "$PURPLE" "$title") $(gum style --foreground "$GREEN" "(DONE)")"
        fi
    fi

    return $exit_code
}

run_step() {
    loading_exec "$1" "$2" "show"
    if [ $? -ne 0 ]; then
        print_failed
        exit 1
    fi
}
