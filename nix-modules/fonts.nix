{ config, lib, pkgs, ... }:

{
    fonts = {
        packages = with pkgs; [
            nerd-fonts.jetbrains-mono 
            noto-fonts-color-emoji
            twemoji-color-font
        ];

        fontconfig = {
            enable = true;
            defaultFonts = {
                monospace = [ "JetBrainsMono Nerd Font" ];
                sansSerif = [ "JetBrainsMono Nerd Font" ];
                serif = [ "JetBrainsMono Nerd Font" ];
                emoji = [ "Noto Color Emoji" ];
            };
        };
    };
}
