{ config, lib, pkgs, ... }:

{
    hardware.cpu.intel.updateMicrocode = true;
    hardware.enableRedistributableFirmware = true;

    hardware.graphics = {
        enable = true;
        enable32Bit = true; 
        extraPackages = with pkgs; [
            intel-media-driver   
        ];
    };

    services.thermald.enable = true;
    services.fstrim.enable = true; 
}
