{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
        # --- Terimnal ---
        kitty

        # --- Development Tools ---
        gcc       
        git
        gnumake  
        curl       
        unzip     
        wl-clipboard 
        slurp
        fastfetch  
        chafa
        gum
        eza
        bat
        python3
        
        # --- Graphical Apps ---
        firefox     

        # --- TUI App ---
        yazi
        calcurse
        btop
        gdu
        impala
        helix
        zellij

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
