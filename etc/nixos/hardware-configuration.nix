{ config, lib, pkgs, modulesPath, user, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # --- Boot ---
  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];

  # --- File System ---
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
  
  fileSystems."/kanso" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@kanso" "compress=zstd:1" "noatime" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };
  
  fileSystems."/vault" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@vault" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };
  
  fileSystems."/persist" = {
    device = "/dev/disk/by-label/vault";
    fsType = "btrfs";
    options = [ "subvol=@persist" "compress=zstd:1" "noatime" ];
    neededForBoot = true;
  };

  # -- persistence  
  environment.persistence."/persist" = {
    hideMounts = true;
    
    directories = [
      "/var/lib/iwd"
      "/var/lib/nixos"
      "/var/log"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.${user} = {
      directories = [
        "Desktop"
        ".cache"
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
