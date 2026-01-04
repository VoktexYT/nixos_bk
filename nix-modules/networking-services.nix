{ config, lib, pkgs, ... }:

{
    # --- Network ---
    networking.wireless.enable = false;
    networking.networkmanager = {
	enable = true;
	wifi.backend = "iwd";
    };
    networking.wireless.iwd.enable = true;

    # --- Time ---
    services.timesyncd.enable = true;

    # --- Sound ---
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true; 
    };

    # --- Access ---
    services.openssh.enable = true;
    programs.ssh.startAgent = true;
}
