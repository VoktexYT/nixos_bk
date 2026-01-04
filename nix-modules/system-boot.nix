{ pkgs, ... }:

{
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.tmp.useTmpfs = true;
    boot.tmp.tmpfsSize = "20G";

    # --- Kernel ---
    boot.kernelPackages = pkgs.linuxPackages_zen;
}
