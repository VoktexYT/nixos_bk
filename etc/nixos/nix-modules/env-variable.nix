{ config, pkgs, ... }:

{
    environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";    
        LIBVA_DRIVER_NAME = "iHD";  
        EDITOR = "hx";
    };

    system.nixos.label = (builtins.fromTOML (builtins.readFile /vault/kanso/pkgs.toml)).generation-label or "";
}
