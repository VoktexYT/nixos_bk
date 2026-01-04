{ config, lib, pkgs, user, ... }:

{
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"   
      "networkmanager"
      "video"  
      "render" 
      "docker"
    ];
    shell = pkgs.fish;
    hashedPassword = "$6$v5G0ed3Zk9LYqs2B$gMGvThpyia.7DI6tGVaWA0/uNfR8N2IEySHaMEgvH7QSA1NfJ0VUF/.AcX.ZPiPiP9zRrwuKFayzmfloSya4d/";
  };

  users.users.root = {
    shell = pkgs.fish;
    hashedPassword = "$6$v5G0ed3Zk9LYqs2B$gMGvThpyia.7DI6tGVaWA0/uNfR8N2IEySHaMEgvH7QSA1NfJ0VUF/.AcX.ZPiPiP9zRrwuKFayzmfloSya4d/";
  };

  users.mutableUsers = false;
}
