{ pkgs, ... }:

let
  kanso-script = builtins.readFile ./cli.sh;
  kanso-cli = pkgs.writeShellScriptBin "kanso" ''
    ${kanso-script}
  '';
in
{
  environment.systemPackages = [
    kanso-cli
    pkgs.gum
  ];
}
