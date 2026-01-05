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
        "qutebrowser".source = config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/qutebrowser;
        "helix".source =       config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/helix;
        "fish".source =        config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/fish;
        "hypr".source =        config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/hyprland;
        "waybar".source =      config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/waybar;
        "kitty".source =       config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/kitty;
        "ytfzf".source =       config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/ytfzf;
        "zellij".source =      config.lib.file.mkOutOfStoreSymlink /kanso/home-configs/zellij;
    };


    programs.git = {
        enable = true;
        userName = user;
        userEmail = "ubguertin@gmail.com";
        extraConfig = {
            safe = {
                directory = "*";
            };

            core = {
                sharedRepository = "world";
            };
        };
    };

    programs.nnn = {
        enable = true;
        package = pkgs.nnn.override { withNerdIcons = true; };
    };
    
    programs.home-manager.enable = true;
    home.stateVersion = "25.11"; 
}
