import subprocess
import sys
import os

COLORS = {
    "green": "#b8bb26",
    "red": "#fb4934",
    "purple": "#d3869b",
    "orange": "#fe8019",
    "bg_dark": "#282828",
    "fg_light": "#ebdbb2",
    "gray": "#928374",
    "blue": "#83a598"
}

def run_cmd(cmd, shell=True, check=False, capture_output=False):
    try:
        result = subprocess.run(
            cmd, 
            shell=shell, 
            check=check, 
            text=True, 
            stdout=subprocess.PIPE if capture_output else None,
            stderr=subprocess.PIPE if capture_output else None
        )
        return result
    except subprocess.CalledProcessError as e:
        if check:
            raise e
        return e

def sudo_auth():
    subprocess.run(["sudo", "-v"])

def print_ok():
    subprocess.run(["gum", "style", "--foreground", COLORS["green"], "--bold", "OK"])

def print_failed():
    subprocess.run(["gum", "style", "--foreground", COLORS["red"], "--bold", "FAILED"])

def gum_confirm(prompt, affirmative="Yes", negative="No"):
    """Wrapper pour gum confirm."""
    res = subprocess.run([
        "gum", "confirm",
        "--prompt.foreground", COLORS["fg_light"],
        "--selected.background", COLORS["orange"],
        "--selected.foreground", COLORS["bg_dark"],
        "--unselected.background", COLORS["bg_dark"],
        "--unselected.foreground", COLORS["gray"],
        "--affirmative", affirmative,
        "--negative", negative,
        prompt
    ])
    return res.returncode == 0

def gum_input(placeholder, password=False):
    cmd = [
        "gum", "input",
        "--placeholder", placeholder,
        "--prompt.foreground", COLORS["fg_light"],
        "--cursor.foreground", COLORS["orange"],
        "--width", "50"
    ]

    if password:
        cmd.append("--password")

    try:
        res = subprocess.run(
            cmd,
            stdin=sys.stdin,        
            stdout=subprocess.PIPE, 
            stderr=None,            
            text=True,
            check=True              
        )

        return res.stdout.strip()
    except subprocess.CalledProcessError:
        return None

def gum_choose(items, header=None, select_one=True):
    cmd = [
        "gum", "choose",
        "--cursor=", 
        "--selected.foreground", COLORS["blue"],
        "--selected.bold",
        "--item.foreground", COLORS["fg_light"]
    ]
    if header:
        cmd.extend(["--header", header, "--header.foreground", COLORS["orange"]])
    
    cmd.extend(items)
    
    try:
        process = subprocess.run(cmd, stdout=subprocess.PIPE, text=True)
        return process.stdout.strip()
    except FileNotFoundError:
        return "Error: gum not found"

def loading_exec(title, cmd):
    full_cmd = f'gum spin --spinner dot --spinner.foreground "{COLORS["orange"]}" --title "{title}" --title.foreground "{COLORS["purple"]}" -- bash -c "{cmd}"'
    res = subprocess.run(full_cmd, shell=True)
    
    if res.returncode == 0:
        print(f"\r\033[38;2;211;134;155m{title}\033[0m \033[38;2;184;187;38m(DONE)\033[0m")
        return True
    else:
        print_failed()
        return False
