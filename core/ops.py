import os
import sys
import subprocess
import rtoml
import tomllib
import tempfile
import signal
import shutil
from datetime import datetime
from core.utils import *
from itertools import zip_longest


PKGS_PATH = "/vault/kanso/settings/packages.toml"
BACKUP_PATH = PKGS_PATH + ".bak"

def safe_write_toml(path, data):
    with tempfile.NamedTemporaryFile('w', delete=False) as tmp:
        tmp_path = tmp.name
        try:
            rtoml.dump(data, tmp, pretty=True)
            tmp.flush()
            os.fsync(tmp.fileno())
            tmp.close()
            
            loading_exec(
                f"Applying changes to {os.path.basename(path)}...",
                f"sudo mv {tmp_path} {path} && sudo chmod 644 {path}"
            )
        except Exception as e:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)
            raise e

def restore_backup(signum=None, frame=None):
    if os.path.exists(BACKUP_PATH):
        loading_exec(f"Restoring backup '{BACKUP_PATH}'...", f"sudo cp {BACKUP_PATH} {PKGS_PATH} && sudo rm {BACKUP_PATH}")
    if signum:
        sys.exit(1)

# --- SYSTEM OPERATIONS ---
def list_pkgs(clear_screen=False):
    if clear_screen:
        os.system("clear")

    try:
        with open(PKGS_PATH, "rb") as f:
            data = tomllib.load(f)
        
        excluded_keys = ["generation-label", "kpm"]
        headers = [h for h in data.keys() if h not in excluded_keys]
        
        columns = [data[h].get("packages", []) if isinstance(data[h], dict) else [] for h in headers]
        col_width = 18

        header_line = "".join([f"{h.capitalize():<{col_width}}" for h in headers])
        print(header_line)
        print("-" * (len(headers) * col_width))

        for row in zip_longest(*columns, fillvalue=""):
            row_str = "".join([f"{str(pkg):<{col_width}}" for pkg in row])
            print(row_str)
            
    except Exception as e:
        print(f"Error listing packages: {e}")


def update_packages(isInstall, clear_screen=False, **queries):
    sudo_auth()
    if clear_screen:
        os.system("clear")
        
    if os.path.exists(BACKUP_PATH):
        restore_backup()

    queries = queries.get("queries")
    if not queries: return

    for sig in [signal.SIGTERM, signal.SIGHUP, signal.SIGINT]:
        signal.signal(sig, restore_backup)

    try:
        with open(PKGS_PATH, "rb") as f:
            data = tomllib.load(f)

        packages = data.get("nixpkgs", {}).get("packages", [])
        updated_packages = []

        for query in queries:
            query_values = query.split(":")

            if len(query_values) != 2:
                print(f"SyntaxError: '{query}' do not respect format '<source>:<package>'")
                print_failed()
                return
            
            source, package = query_values

            if source not in data:
                print(f"ValueError: The source '{source}' does not exist")
                print_failed()
                return
            
            if isInstall: 
                if package not in packages:
                    packages.append(package)
                else:
                    print(f"Package '{package}' is already installed!")
                    print_failed()
                    return
            else: 
                if package in packages:
                    packages.remove(package)
                else:
                    print(f"Package '{package}' is not installed!")
                    print_failed()
                    return

            updated_packages.append(package)

        
        state_message = "Install" if isInstall else "Remove"
        format_package_names = '.'.join(updated_packages)
        generation_label_message = f"{state_message}:{format_package_names}"

        loading_exec(f"Backing up {PKGS_PATH}...", f"sudo cp {PKGS_PATH} {BACKUP_PATH}")
        
        data["nixpkgs"]["packages"] = packages
        data["generation-label"] = generation_label_message

        safe_write_toml(PKGS_PATH, data)
        
        loading_exec(f"{state_message} {format_package_names}...", "kanso rebuild")
        loading_exec(f"Cleaning backup...", f"sudo rm {BACKUP_PATH}")
                
        print_ok()

    except (KeyboardInterrupt, Exception) as e:
        restore_backup()
        if not isinstance(e, KeyboardInterrupt):
            print(f"ERROR: {e}")
        print_failed()
       
def sync_pkgs(clear_screen=False):
    sudo_auth()
    if clear_screen:
        os.system("clear")

    with open(PKGS_PATH, "rb") as f:
        data = tomllib.load(f)

    loading_exec("Syncing kpm...", "echo kpm")
    loading_exec("Syncing nixpkgs...", "kanso rebuild")
    loading_exec("Syncing flatpak...", "echo flatpak")
    loading_exec("Syncing aur...", "echo aur")
    loading_exec("Syncing appimage", "echo appimage")
    print_ok()


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

