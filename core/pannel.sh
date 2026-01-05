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
    gum choose --cursor="" --header=" " --height=10 \
        --selected.foreground="$COLOR_SELECTED" --selected.bold \
        --item.foreground="$COLOR_ITEM" "$@"
}

launch_app() {
    local cmd="$1"
    kitty --class="app_center" -o background="#000" -e $cmd
}

launch_program() {
    local cmd="$1"
    kitty --class="app_center" -o background="#000" sh -c "$cmd; read -n 1 -s"
}

# --- EXECUTION ---
draw_title

MAIN_CHOICE=$(menu_choose "System" "Applications" "Monitor" "Network" "Power" "Exit")

case $MAIN_CHOICE in

"Applications")
    APP_CHOICE=$(menu_choose "Calendar" "Disk Manager" "File Explorer" "Kanso YouTube" "Kanso Code Editor")
    case $APP_CHOICE in
        "Calendar")          launch_app "calcurse" ;;
        "Disk Manager")      launch_app "gdu" ;;
        "File Explorer")     launch_app "yazi" ;;
        "Kanso YouTube")     launch_app "kanso watch-youtube" ;;
        "Kanso Code Editor") launch_app "kanso code-editor" ;;
    esac
    ;;

"System")
    SYS_CHOICE=$(menu_choose "Information" "Rebuild" "Rollback" "Refresh Desktop" "Create Snapshot" "Rewind Snapshot" "Hard Clean")
    case $SYS_CHOICE in
        "Rebuild")         launch_program "kanso rebuild clear" ;;
        "Rollback")        launch_program "kanso rollback clear" ;;
        "Create Snapshot") launch_program "kanso snapshot class::clear" ;;
        "Rewind Snapshot") launch_program "kanso rewind clear" ;;
        "Hard Clean")      launch_program "kanso hard-clean clear" ;;
        "Refresh Desktop") launch_program "kanso refresh-desktop" ;;
        "Information")     launch_program "fastfetch" ;;
    esac
    ;;

"Network") launch_app "impala" ;;

"Monitor") launch_app "btop" ;;

"Power")
    PWR_CHOICE=$(menu_choose "Reboot" "Shutdown" "Logout" )
    [ "$PWR_CHOICE" == "Reboot" ] && reboot
    [ "$PWR_CHOICE" == "Shutdown" ] && shutdown now
    [ "$PWR_CHOICE" == "Logout" ] && hyprctl dispatch exit
    ;;

"Exit") exit 0 ;;
esac
