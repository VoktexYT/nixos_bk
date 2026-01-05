#!/usr/bin/env python3
import os
import sys
import subprocess
from core.utils import gum_choose, COLORS

os.environ["GUM_CHOOSE_CURSOR_FOREGROUND"] = "#89b4fa"
os.environ["GUM_CHOOSE_HEADER_FOREGROUND"] = "#D65D0E"

def draw_title():
    width = os.get_terminal_size().columns - 2
    subprocess.run([
        "gum", "style",
        "--foreground", "#B16286",
        "--border-foreground", "#B16286",
        "--border", "double",
        "--align", "center",
        "--width", str(width),
        "KANSO CENTER"
    ])

def launch_app_window(cmd):
    subprocess.Popen(
        ["kitty", "--class=app_center", "-o", "background=#000", "-e"] + cmd.split(),
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True
    )
    sys.exit(0)

def launch_prog_window(cmd):
    full_cmd = f'sh -c "{cmd}; read -n 1 -s"'
    subprocess.Popen(
        ["kitty", "--class=app_center", "-o", "background=#000", "-e", "sh", "-c", full_cmd],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        start_new_session=True
    )
    sys.exit(0)

def main():
    os.system("tput civis")
    try:
        while True:
            os.system("clear")
            draw_title()     
       
            main_choice = gum_choose(
                ["System", "Applications", "Monitor", "Network", "Power", "Exit"],
                header=" "
            )

            if main_choice == "Exit" or not main_choice:
                break

            if main_choice == "Applications":
                app = gum_choose(
                    ["Calendar", "Disk Manager", "File Explorer", "Kanso YouTube", "Kanso Code Editor"],
                    header=" "
                )

                if app == "Calendar": launch_app_window("calcurse")
                elif app == "Disk Manager": launch_app_window("gdu")
                elif app == "File Explorer": launch_app_window("yazi")
                elif app == "Kanso YouTube": launch_app_window("kanso watch-youtube")
                elif app == "Kanso Code Editor": launch_app_window("kanso code-editor")

            elif main_choice == "System":
                sys_act = gum_choose(
                    ["Information", "Rebuild", "Rollback", "Refresh Desktop", 
                     "Create Snapshot", "Rewind Snapshot", "Hard Clean"],
                     header=" "
                )

                if sys_act == "Rebuild": launch_prog_window("kanso rebuild class::clear")
                elif sys_act == "Rollback": launch_prog_window("kanso rollback class::clear")
                elif sys_act == "Create Snapshot": launch_prog_window("kanso snapshot class::clear")
                elif sys_act == "Rewind Snapshot": launch_prog_window("kanso rewind class::clear")
                elif sys_act == "Hard Clean": launch_prog_window("kanso hard-clean class::clear")
                elif sys_act == "Refresh Desktop": launch_prog_window("kanso refresh-desktop")
                elif sys_act == "Information": launch_prog_window("fastfetch")

            elif main_choice == "Network":
                launch_app_window("impala")

            elif main_choice == "Monitor":
                launch_app_window("btop")

            elif main_choice == "Power":
                pwr = gum_choose(["Reboot", "Shutdown", "Logout"])
                if pwr == "Reboot": subprocess.run(["reboot"])
                elif pwr == "Shutdown": subprocess.run(["shutdown", "now"])
                elif pwr == "Logout": subprocess.run(["hyprctl", "dispatch", "exit"])
    finally:
        os.system("tput cnorm")

if __name__ == "__main__":
    main()
