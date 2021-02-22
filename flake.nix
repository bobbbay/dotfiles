{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, home-manager, nixpkgs, ... }: {
    nixosConfigurations = {
      NotYourPC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bobbbay = import ./home-manager/bobbbay;
          } 
        ];
      };
    };
  };

#    let
#      pkgs = (import nixpkgs) {
#        system = "x86_64-linux";
#      };

#      targets = map (pkgs.lib.removeSuffix ".nix") (
#        pkgs.lib.attrNames (
#          pkgs.lib.filterAttrs
#            (_: entryType: entryType == "regular")
#            (builtins.readDir ./targets)
#        )
#      );

#      build-target = target: {
#        name = target;

#        value = nixpkgs.lib.nixosSystem {
#          system = "x86_64-linux";
#          modules = [
#            home-manager.nixosModules.home-manager
#            (import (./targets + "/${target}.nix"))
#            (import (./targets + "/${target}/hardware-configuration.nix"))
#          ];
#        };
#      };

#    in
#    {
#      nixosConfigurations = builtins.listToAttrs (
#        pkgs.lib.flatten (
#          map (
#            target: [ (build-target target ) ]
#          )
#          targets
#        )
#      );
#    };
}
