{ config, lib, pkgs, user, ... }:
{
  nix.settings = {
    trusted-users = ["nix-deamon"];
    allowed-users = ["@wheel" user];
  };
}
