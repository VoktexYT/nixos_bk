{
  description = "Kanso Architecture - VoktexYT";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      user = "voktex";
    in
    {
      nixosConfigurations.${user} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs user; };
        modules = [
          /vault/etc/nixos/configuration.nix
          inputs.impermanence.nixosModules.impermanence
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs user; };
            home-manager.users.${user} = import ./home.nix;
          }
        ];
      };
    };
}
