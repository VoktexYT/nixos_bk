{ config, lib, pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
  };
}
