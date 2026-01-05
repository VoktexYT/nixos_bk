import os
import sys
import subprocess
from core.utils import *

# --- APPLICATIONS ---

def watch_youtube(query=None):
    if not query:
        query = gum_input("YouTube Search...")
        if not query:
            print("Search cancelled.")
            return

    os.system("clear")
    cmd = f'ytfzf -t --video-pref="480p" "{query}"'
    os.system(cmd)

def code_editor():
    subprocess.run(["zellij", "--layout", "dev"])

# --- SYSTEM OPERATIONS ---

def snapshot(name=None, clear_screen=False):
    sudo_auth()
    if clear_screen:
        os.system("clear")

    if not name:
        name = gum_input("Snapshot Name...")

    if not name:
        print("Operation canceled...")
        return

    cmd = f"sudo git -C /vault add . && sudo git -C /vault -c user.name='root' -c user.email='root@kanso.local' commit -m \"{name}\""

    if loading_exec(f"Creating snapshot '{name}'...", cmd):
        print_ok()
    else:
        print_failed()
        
def rebuild(clear_screen=False):
    sudo_auth()
    if clear_screen:
        os.system("clear")

    log_file = "/tmp/kanso_rebuild.log"
    cmd = f"sudo nixos-rebuild switch --flake /vault/etc/nixos#voktex --impure > /dev/null 2> {log_file}"
    
    if loading_exec("Rebuild system...", cmd):
        print_ok()
        if os.path.exists(log_file):
            os.remove(log_file)
    else:
        print_failed()
        if os.path.exists(log_file):
            os.system(f"cat {log_file} | gum format -t code --language bash")
            os.remove(log_file)
        sys.exit(1)

def refresh_desktop():
    steps = [
        ("Stopping Waybar...", "pkill waybar"),
        ("Starting Waybar...", "hyprctl dispatch exec waybar"),
        ("Reloading Hyprland...", "hyprctl reload")
    ]
    
    for title, cmd in steps:
        if not loading_exec(title, cmd):
            sys.exit(1)
    print_ok()

def rollback(clear_screen=False):
    sudo_auth()
    if clear_screen:
        os.system("clear")
    
    os.environ["COLORTERM"] = "truecolor"
    
    try:
        raw_gens = subprocess.check_output(
            ["sudo", "nix-env", "--list-generations", "--profile", "/nix/var/nix/profiles/system"],
            text=True
        )
    except subprocess.CalledProcessError:
        print_failed()
        return

    gens_list = [line for line in raw_gens.splitlines() if line.strip()]
    
    selection = gum_choose(gens_list, header="Select generation to restore:")
    if not selection:
        print("Operation cancelled.")
        return

    gen_id = selection.split()[0]
    if not gum_confirm(f"Are you sure you want to restore generation {gen_id}?", "Restore", "Cancel"):
        print("Operation cancelled")
        return

    if not loading_exec("Symlink Management...", f"sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation {gen_id}"): return
    if not loading_exec("System Rollback...", "sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch"): return
    print_ok()

def rewind(clear_screen=False):
    sudo_auth()
    if clear_screen:
        os.system("clear")
    
    if not os.path.exists("/vault"):
        print("Error: /vault directory not found.")
        return

    try:
        git_log = subprocess.check_output(
            ["git", "-C", "/vault", "log", "--oneline", "--format=%h | %ad | %s", "--date=short"],
            text=True
        )
    except subprocess.CalledProcessError:
        print("Error reading git log.")
        return

    lines = [l for l in git_log.splitlines() if l.strip()]
    selection = gum_choose(lines, header="Select configuration to restore:")
    
    if not selection:
        print("No version selected.")
        return

    commit_hash = selection.split('|')[0].strip()

    if not gum_confirm(f"Discard changes after {commit_hash}?", "Restore", "Cancel"):
        print("Operation cancelled")
        return

    loading_exec(f"Restoring to {commit_hash}...", f"sudo git -C /vault reset --hard {commit_hash}")

def hard_clean(clear_screen=False):
    sudo_auth()
    if clear_screen:
        os.system("clear")

    msg = "This will delete all previous system generations and config snapshot. Are you sure?"
    if not gum_confirm(msg, "Yes", "No"):
        print("Operation cancelled.")
        return

    steps = [
        ("Cleaning user generations...", "nix-env --delete-generations old"),
        ("Cleaning system generations...", "sudo nix-collect-garbage -d"),
        ("Updating boot menu...", "sudo /run/current-system/bin/switch-to-configuration boot"),
        ("Optimizing Nix store...", "nix-store --optimise"),
        ("Deleting snapshot history...", "sudo rm -rf /vault/.git"),
        ("Initializing stable snapshot...", "sudo git -C /vault init")
    ]

    for title, cmd in steps:
        loading_exec(title, cmd)

    snapshot("STABLE")
    print_ok()
