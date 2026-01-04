{ config, lib, pkgs, inputs, user, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ./nix-modules/programs.nix
        ./nix-modules/graphical-env.nix
        ./nix-modules/hardware.nix
        ./nix-modules/networking-services.nix
        ./nix-modules/system-boot.nix
        ./nix-modules/users.nix
        ./nix-modules/virtualization.nix
        ./nix-modules/fonts.nix
        ./nix-modules/env-variable.nix
        ./nix-modules/time.nix
        ./nix-modules/kanso-os-system.nix
        ./kanso/kanso-cli.nix
        ./kanso/kanso-pannel.nix
    ];
    
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "25.11";
}
