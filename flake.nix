{
  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    emacs.url = "github:nix-community/emacs-overlay";
    fenix.url = "github:nix-community/fenix";
    home.url = "github:nix-community/home-manager/release-21.05";
    doom.url = "github:vlaci/nix-doom-emacs";

    # neomacs.url = "github:vi-tality/neomacs";
    neomacs.url = "/home/demo/projects/neomacs";
    neovim.url = "github:neovim/neovim?dir=contrib";
  };

  outputs =
    inputs@{
      self
    , utils
    , nixpkgs
    , unstable
    , nur
    , emacs
    , home
    , fenix
    , doom
    , neomacs
    , neovim
    , ...
    }:
      with builtins;
      let
        pkgs = self.pkgs.x86_64-linux.nixpkgs;
      in
      utils.lib.mkFlake {
        inherit self inputs;

        supportedSystems = [ "x86_64-linux" ];

        channelsConfig = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };

        overlay = import ./overlays;

        sharedOverlays = [
          self.overlay
          nur.overlay
          emacs.overlay
          fenix.overlay

          (
            final: prev: {
              unstable = unstable.legacyPackages.${prev.system};
              neovim-nightly = neovim.defaultPackage.${prev.system};
            }
          )
        ];

        channels.nixpkgs.input = nixpkgs;
        channels.unstable.input = unstable;

        hostDefaults.modules = [
          ./modules/cachix.nix
          ./modules/media.nix
          ./modules/guacamole.nix

          home.nixosModules.home-manager

          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ ./suites ./profiles ./modules/home ./programs doom.hmModule neomacs.hmModule ];
          }
        ];

        nixosModules = utils.lib.exportModules [
          ./hosts/NotYourPC
          ./hosts/NotYourLaptop
          ./hosts/NotYourVM
        ];

        hosts = {
          NotYourPC.modules = with self.nixosModules; [ NotYourPC ];
          NotYourLaptop.modules = with self.nixosModules; [ NotYourLaptop ];
          NotYourVM.modules = with self.nixosModules; [ NotYourVM ];
        };

        outputsBuilder = channels: with channels.nixpkgs; {
          devShell = mkShell {
            name = "sysconfig";
            buildInputs = [
              cachix
              nixpkgs-fmt
              nixos-generators
              git-crypt
            ];
          };
        };
      };
}
