{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        # Test
        cbonsai
        
        # --- Terimnal ---
        kitty

        # --- Development Tools ---
        gcc       
        git
        gnumake  
        nodejs  
        python3
        curl       
        unzip     
        wl-clipboard 
        slurp
        php 
        fastfetch  
        chafa
        gum
        eza
        bat
        
        # --- Graphical Apps ---
        firefox     
        qutebrowser 

        # --- TUI App ---
        yazi
        calcurse
        btop
        gdu
        impala
        helix

        ## Youtube
        ytfzf 
        yt-dlp 
        mpv 
        jq

        # -- Windows Components --
        waybar
        hyprpaper
        grim
        bibata-cursors
        zellij
    ];


    # =================================================================
    # PROGRAMS & COMPATIBILITY
    # =================================================================
    programs.fish.enable = true;
    programs.zoxide.enable = true; 

    programs.nix-ld.enable = true;
    programs.nix-ld.libraries = with pkgs; [
        stdenv.cc.cc
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat
    ];

    nixpkgs.config.allowUnfree = true;
}
