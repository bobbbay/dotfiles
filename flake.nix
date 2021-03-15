{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-20.09;
    unstable.url = github:nixos/nixpkgs/nixos-unstable;
    nur.url = github:nix-community/NUR;
    home-manager.url = github:nix-community/home-manager/release-20.09;
    emacs-overlay = {
      url = github:nix-community/emacs-overlay;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-doom-emacs = {
      url = github:vlaci/nix-doom-emacs;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };

    flake-utils = {
      url = github:numtide/flake-utils;
    };

    utils.url = github:gytis-ivaskevicius/flake-utils-plus;

    neovim = {
      url = github:neovim/neovim?dir=contrib;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nix-doom-emacs, nur, unstable, utils, neovim, ... }: 
  let
    pkgs = self.pkgs.nixpkgs;
    hmImports = with inputs; [ nix-doom-emacs.hmModule ];
  in
    utils.lib.systemFlake {
      inherit self inputs;

      defaultSystem = "x86_64-linux";
      overlays = import ./overlays;

      channels.nixpkgs = {
        input = nixpkgs;
      };

      channels.unstable.input = unstable;
      channels.unstable.overlaysFunc = channels: [
        (final: prev: {
          neovim-nightly = neovim.defaultPackage.${prev.system};
        })
      ];

      channelsConfig = {
        allowUnfree = true;
      };

      nixosProfiles = {
        NotYourPC = {
          nixpkgs = pkgs;
          modules = [
            (import ./configuration.nix)
          ];
        };
      };

      sharedOverlays = [
        self.overlays
        nur.overlay
      ];

      sharedModules = [
        home-manager.nixosModules.home-manager
        {
          # nix = utils.lib.nixDefaultsFromInputs inputs;

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # home-manager.users.bobbbay.imports = hmImports ++ [ ./home-manager/bobbbay ];
        }
      ];
    };

#    nixosConfigurations = {
#      NotYourPC = nixpkgs.lib.nixosSystem {
#        system = "x86_64-linux";
#        modules = [ 
#          ./configuration.nix
#          home-manager.nixosModules.home-manager
#          {
#            home-manager.useGlobalPkgs = true;
#            home-manager.useUserPackages = true;
#            home-manager.users.bobbbay.imports = hmImports ++ [ ./home-manager/bobbbay ];
#          } 
#        ];
#      };
#    };

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
