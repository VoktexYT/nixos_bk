{ config, lib, user, ... }:

{
    environment.etc."os-release".text = lib.mkForce ''
        NAME="KANSO"
        ID=kanso
        ID_LIKE=nixos
        PRETTY_NAME="KANSO"
        ANSI_COLOR="0;34"
        HOME_URL=""
        SUPPORT_URL=""
        BUG_REPORT_URL=""
        LOGO="${../kanso-logo.png}"
    '';

    environment.etc."fastfetch/config.jsonc".text = ''
        {
            "logo": {
                "source": "${../kanso-logo.png}",
                "type": "kitty",
            },

            "display": {
                "separator": " ➔ ",
                "color": {
                    "keys": "magenta"
                }
            },

            "modules": [
                "break",
                "break",
                "title",
                "separator",
                {
                    "type": "os",
                    "key": "OS      "
                },
                {
                    "type": "host",
                    "key": "Host    "
                },
                {
                    "type": "kernel",
                    "key": "Kernel  "
                },
                {
                    "type": "uptime",
                    "key": "Uptime  "
                },
                {
                    "type": "packages",
                    "key": "Packages"
                },
                {
                    "type": "shell",
                    "key": "Shell   "
                },
                {
                    "type": "display",
                    "key": "Display "
                },
                {
                    "type": "wm",
                    "key": "WM      "
                },
                {
                    "type": "terminal",
                    "key": "Terminal"
                },
                {
                    "type": "cpu",
                    "key": "CPU     "
                },
                {
                    "type": "gpu",
                    "key": "GPU     "
                },
                {
                    "type": "memory",
                    "key": "Memory  "
                },
                {
                    "type": "disk",
                    "key": "Disk    "
                },
                {
                    "type": "battery",
                    "key": "Battery "
                },
                "break",
                "colors"
            ]
        }
    '';
}
