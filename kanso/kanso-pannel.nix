{ pkgs, ... }:

let
  kanso-pannel = pkgs.writeShellScriptBin "kanso-pannel" ''
    exec kitty --class="pannel_center" -o background=#000 -e ${./pannel.sh}
  '';
in
{
  environment.systemPackages = [
    kanso-pannel
    pkgs.gum
  ];
}
