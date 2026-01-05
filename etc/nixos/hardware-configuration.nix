{ config, lib, pkgs, modulesPath, user, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # --- Boot ---
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  # --- File System ---
  fileSystems."/vault" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@vault" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:1" "noatime" "nodev" "nosuid" ];
    neededForBoot = true;
  };

  fileSystems."/kanso" = {
    device = "/vault/kanso";
    options = [ "bind" ];
  };

  fileSystems."/vault/kanso" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@kanso" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };

  fileSystems."/vault/core" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@core" "compress=zstd:1" "noatime" ];
  };

  # --- Root in RAM ---
  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "mode=755" "size=8G" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/BOOT";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  
  environment.persistence."/vault" = {
    hideMounts = true;
    directories = [
      "/var/lib/iwd"
      "/var/lib/nixos"
      "/etc/nixos"
    ];

    files = [ "/etc/machine-id" ];

    users.${user} = {
      directories = [ ".ssh" "Desktop" ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
