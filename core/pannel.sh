#!/bin/sh

export GUM_CHOOSE_CURSOR_FOREGROUND="#89b4fa"
export GUM_CHOOSE_HEADER_FOREGROUND="#D65D0E"

COLOR_TITLE="#B16286"
COLOR_SELECTED="#83a598"
COLOR_ITEM="#ebdbb2"

tput civis
trap "tput cnorm; exit" SIGINT SIGTERM EXIT
clear

# --- FUNCTIONS ---
draw_title() {
    local width=$(($(tput cols) - 2))
    gum style --foreground "$COLOR_TITLE" --border-foreground "$COLOR_TITLE" \
        --border double --align center --width "$width" "KANSO CENTER"
}

menu_choose() {
    gum choose --cursor="" --header=" " \
        --selected.foreground="$COLOR_SELECTED" --selected.bold \
        --item.foreground="$COLOR_ITEM" "$@"
}

launch_app() {
    local cmd="$1"
    local mode="$2"

    if [ "$mode" == "hold" ]; then
        kitty --class="app_center" -o background="#000" sh -c "$cmd; read -n 1 -s"
    else
        kitty --class="app_center" -o background="#000" -e $cmd
    fi
}

# --- EXECUTION ---
draw_title

MAIN_CHOICE=$(menu_choose "System" "Applications" "Monitor" "Network" "Power" "Exit")

case $MAIN_CHOICE in

"Applications")
    APP_CHOICE=$(menu_choose "Calendar" "Disk Manager" "File Explorer" "YouTube" "Kanso Code")
    case $APP_CHOICE in
    "Calendar") launch_app "calcurse" ;;
    "Disk Manager") launch_app "gdu" ;;
    "File Explorer") launch_app "yazi" ;;
    "YouTube") launch_app "kanso watch" ;;
    "Kanso Code") launch_app "kanso code" ;;
    esac
    ;;

"System")
    SYS_CHOICE=$(menu_choose "Rebuild" "Hard Clean" "Refresh Desktop" "Rollback" "Information")
    case $SYS_CHOICE in
    "Rebuild") launch_app "kanso rebuild clear" "hold" ;;
    "Hard Clean") launch_app "kanso hard-clean clear" "hold" ;;
    "Refresh Desktop") launch_app "kanso refresh-desktop" "hold" ;;
    "Information") launch_app "fastfetch" "hold" ;;
    "Rollback") launch_app "kanso rollback clear" "hold" ;;
    esac
    ;;

"Network") launch_app "impala" ;;

"Monitor") launch_app "btop" ;;

"Power")
    PWR_CHOICE=$(menu_choose "Reboot" "Shutdown")
    [ "$PWR_CHOICE" == "Reboot" ] && reboot
    [ "$PWR_CHOICE" == "Shutdown" ] && shutdown now
    ;;

"Exit") exit 0 ;;
esac
