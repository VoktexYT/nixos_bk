{
  config,
  lib,
  pkgs,
  modulesPath,
  user,
  ...
}:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/vault" = {
    device = "/dev/disk/by-uuid/2aee802b-4bf2-4bf5-83d4-28f7896a4967";
    fsType = "ext4";
    neededForBoot = true;
  };

  environment.persistence."/vault" = {
    hideMounts = true;
    directories = [
      "/var/lib/iwd"
      "/var/log"
      "/var/lib/nixos"
      "/etc/nixos"
    ];

    files = [
      "/etc/machine-id"
    ];

    users.${user} = {
      directories = [
        ".ssh"
        "Desktop"
      ];
    };
  };

  fileSystems."/nix" = {
    device = "/vault/nix";
    options = [ "bind" ];
    neededForBoot = true;
  };

  fileSystems."/" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [
      "mode=755"
      "size=8G"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E767-433C";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
