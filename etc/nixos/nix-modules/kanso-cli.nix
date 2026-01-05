{ pkgs, ... }:

let
  kanso-cli = pkgs.stdenv.mkDerivation {
    name = "kanso";
    src = /vault/core; 

    installPhase = ''
      mkdir -p $out/bin
      cp cli.sh $out/bin/kanso
      cp -r scripts apps $out/bin/
      chmod +x $out/bin/kanso
    '';
  };
in
{
  environment.systemPackages = [
    kanso-cli
    pkgs.gum
  ];
}
