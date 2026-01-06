{ config, pkgs, ... }:

let
  tomlPath = /vault/kanso/pkgs.toml;
  
  userCfg = builtins.fromTOML (builtins.readFile tomlPath);
  
  userPackages = map (name: pkgs.${name}) userCfg.nixpkgs.packages;

  kansoCore = with pkgs; [
    kitty
    fastfetch
    waybar
    wayland
    hyprpaper
    wl-clipboard
    gum
    python3
    git
    curl
    unzip
    grim
    slurp
    bibata-cursors
  ];

in {
  environment.systemPackages = kansoCore ++ userPackages;

  programs.fish.enable = true;
  programs.zoxide.enable = true; 
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc zlib glib openssl icu nss nspr curl expat fuse3
    libGL libxkbcommon wayland mesa libdrm
    xorg.libX11 xorg.libXcursor xorg.libXrandr xorg.libXi
    xorg.libXext xorg.libXcomposite xorg.libXdamage xorg.libXfixes
    xorg.libXrender xorg.libXtst cairo pango atk at-spi2-atk
    gdk-pixbuf gtk3 libdbusmenu-gtk3 libpulseaudio alsa-lib
    dbus libusb1
  ];
}

