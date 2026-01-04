{ config, lib, pkgs, ... }:

{
    programs.hyprland.enable = true;
  
    services.dbus.enable = true;

    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [ 
            pkgs.xdg-desktop-portal-hyprland 
            pkgs.xdg-desktop-portal-gtk 
        ];
    };

    services.greetd = {
        enable = true;
        settings = {
            default_session = {
                command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --asterisks --cmd Hyprland";
                user = "greeter";
            };
        };
    };

    services.displayManager.defaultSession = "hyprland";
}
