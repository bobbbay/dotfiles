{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home-manager.url = "github:nix-community/home-manager/release-20.09";

    flake-utils.url = "github:numtide/flake-utils";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, nur, unstable, utils, ... }:
    with builtins;
    let
      pkgs = self.pkgs.nixpkgs;
      inherit (nixpkgs) lib;
    in utils.lib.systemFlake {
      lib = {
        importDirToAttrs = dir:
          lib.pipe dir [
            lib.filesystem.listFilesRecursive
            (filter (lib.hasSuffix ".nix"))
            (map (path: {
              name = lib.pipe path [
                toString
                (lib.removePrefix "${toString dir}/")
                (lib.removeSuffix "/default.nix")
                (lib.removeSuffix ".nix")
                self.lib.kebabCaseToCamelCase
                (replaceStrings [ "/" ] [ "-" ])
              ];
              value = import path;
            }))
            listToAttrs
          ];

        kebabCaseToCamelCase =
          replaceStrings (map (s: "-${s}") lib.lowerChars) lib.upperChars;

        homeManagerConfiguration =
          let
            homeDirectoryPrefix = pkgs:
              if pkgs.stdenv.hostPlatform.isDarwin then "/Users" else "/home";
          in
          { username
          , configuration
            # Optional arguments
          , system ? "x86_64-linux"
          , extraModules ? [ ]
          , extraSpecialArgs ? { }
          , pkgs ? (self.lib.pkgsForSystem { inherit system; })
          , homeDirectory ? "${homeDirectoryPrefix pkgs}/${username}"
          , isGenericLinux ? pkgs.stdenv.hostPlatform.isLinux
          }:
          home-manager.lib.homeManagerConfiguration {
            inherit username homeDirectory system pkgs;

            extraSpecialArgs = {
              inherit (inputs) dotfiles hardware;
            } // extraSpecialArgs;

            extraModules = homeManagerExtraModules ++ extraModules;
            configuration = {
              imports = [ configuration ];
              targets.genericLinux.enable = isGenericLinux;
            };
          };

      };

      inherit self inputs;

      defaultSystem = "x86_64-linux";
      channels.nixpkgs = { input = nixpkgs; };
      channels.unstable.input = unstable;
      channelsConfig = { allowUnfree = true; };

      nixosProfiles = {
        NotYourPC = {
          nixpkgs = pkgs;
          modules = [ (import ./configuration.nix) ];
        };
        NotYourLaptop = {
          nixpkgs = pkgs;
          modules = [ (import ./host/laptop.nix) ];
        };
      };

      sharedOverlays = [ nur.overlay ];

      sharedModules = with self.nixosModules; [


        home-manager.nixosModules.home-manager
        utils.nixosModules.saneFlakeDefaults
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bobbbay = import ./home.nix;
        }
      ];

      nixosModules = utils.lib.modulesFromList [
        # Add module files here
      ];
      homeManagerModules = self.lib.importDirToAttrs ./home/modules;

      homeManagerConfigurations = {
        bobbbay = self.lib.homeManagerConfiguration {
          username = "bobbbay";
        };
      };

      # nixosModules = utils.lib.modulesFromList [
      #   ./home/cli.nix
      # ];

      # sharedModules = with self.nixosModules; [
      #   cli
      # ];

      # sharedModules = [
      #  home-manager.nixosModules.home-manager
      #  {
      #    home-manager.useGlobalPkgs = true;
      #    home-manager.useUserPackages = true;
      #    home-manager.users.bobbbay.imports = [ ./home ];
      #  }
      # ];
    };
}
