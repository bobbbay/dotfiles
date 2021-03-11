{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = "github:vlaci/nix-doom-emacs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    comma = {
      url = "github:shopify/comma";
      flake = false;
    };
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nix-doom-emacs, comma, ... }: 
  let
    hmImports = with inputs; [ nix-doom-emacs.hmModule ];
  in {
    nixosConfigurations = {
      NotYourPC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.bobbbay.imports = hmImports ++ [ ./home-manager/bobbbay ];
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
