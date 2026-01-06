{ pkgs, lib, ... }:

let
  python3Env = pkgs.python3.withPackages (ps: with ps; [ 
    rtoml 
  ]);

  kanso-cli = pkgs.stdenv.mkDerivation {
    name = "kanso";
    src = /vault/core; 

    buildInputs = [ python3Env ];
    nativeBuildInputs = [ pkgs.makeWrapper ];

    installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/share/kanso/core

        cp -r * $out/share/kanso/core/

        echo "#!${pkgs.bash}/bin/bash" > $out/bin/.kanso-panel-logic
        echo "export PYTHONPATH=$out/share/kanso:\$PYTHONPATH" >> $out/bin/.kanso-panel-logic
        echo "${python3Env}/bin/python3 $out/share/kanso/core/panel.py \"\$@\"" >> $out/bin/.kanso-panel-logic
        chmod +x $out/bin/.kanso-panel-logic

        echo "#!${pkgs.bash}/bin/bash" > $out/bin/kanso-panel
        echo "exec ${pkgs.kitty}/bin/kitty --class=\"panel_center\" -o \"background=#000000\" -e $out/bin/.kanso-panel-logic" >> $out/bin/kanso-panel
        chmod +x $out/bin/kanso-panel

        echo "#!${pkgs.bash}/bin/bash" > $out/bin/kanso
        echo "export PYTHONPATH=$out/share/kanso:\$PYTHONPATH" >> $out/bin/kanso
        echo "${python3Env}/bin/python3 $out/share/kanso/core/cli.py \"\$@\"" >> $out/bin/kanso
        chmod +x $out/bin/kanso
    '';
  };
in
{
  environment.systemPackages = [
    kanso-cli
    pkgs.gum
    pkgs.git
  ];

  environment.etc."os-release".text = lib.mkForce ''
    NAME="KANSO"
    ID=kanso
    ID_LIKE=nixos
    PRETTY_NAME="KANSO"
    ANSI_COLOR="0;34"
    HOME_URL=""
    SUPPORT_URL=""
    BUG_REPORT_URL=""
    LOGO="${/vault/core/assets/kanso-logo.png}"
  '';

  environment.etc."fastfetch/config.jsonc".text = ''
  {
      "logo": {
          "source": "${/vault/core/assets/kanso-logo.png}",
          "type": "kitty"
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

