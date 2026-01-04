{ config, pkgs, user, ... }:

{
    home.username = user;
    home.homeDirectory = "/home/${user}";

    xdg.userDirs = {
        enable = true;
        createDirectories = true;
        download = "${config.home.homeDirectory}/Downloads";    
        videos = "${config.home.homeDirectory}/Videos";    
        pictures = "${config.home.homeDirectory}/Pictures";
        desktop = "${config.home.homeDirectory}/Desktop";    
        documents = null;
        music = null;
        templates = null;
        publicShare = null;
    };
    
    xdg.configFile = {
        "qutebrowser".source = ./app-configs/qutebrowser;
        "helix".source = ./app-configs/helix;
        "fish".source = ./app-configs/fish;
        "hypr".source = ./app-configs/hyprland;
        "waybar".source = ./app-configs/waybar;
        "wofi".source = ./app-configs/wofi;
        "kitty".source = ./app-configs/kitty;
        "ytfzf".source = ./app-configs/ytfzf;
        "zellij".source = ./app-configs/zellij;
    };

    home.packages = with pkgs; [
        htop
        fzf
        ripgrep
    ];

    programs.git = {
        enable = true;
        settings.user = {
            name = user;
            email = "ubguertin@gmail.com";
        };
    };

    programs.nnn = {
        enable = true;
        package = pkgs.nnn.override { withNerdIcons = true; };
    };
    
    programs.home-manager.enable = true;
    home.stateVersion = "25.11"; 
}
