{
  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    home.url = "github:nix-community/home-manager/release-21.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    emacs.url = "github:nix-community/emacs-overlay";
    fenix.url = "github:nix-community/fenix";

    neovim.url = "github:neovim/neovim?dir=contrib";

    wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs =
    inputs@{ self
    , utils
    , nixpkgs
    , unstable
    , nur
    , emacs
    , home
    , fenix
    , neovim
    , wsl
    , ...
    }:
      let
        inherit (utils.lib) mkFlake exportModules;
        pkgs = self.pkgs.x86_64-linux.nixpkgs;
      in
        mkFlake {
          inherit self inputs;

          supportedSystems = [ "x86_64-linux" ];

          channelsConfig = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };

          overlay = import ./overlays;

          channels.nixpkgs.overlaysBuilder = channels: [
            self.overlay
            nur.overlay
            emacs.overlay
            fenix.overlay

            (
              final: prev: {
                unstable = unstable.legacyPackages.${prev.system};
              }
            )
          ];

          hostDefaults.modules = [
            ./modules

            ./modules/cachix.nix
            ./modules/media.nix

            ./modules/options.nix

            wsl.nixosModules.wsl
            home.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ ./programs ];
            }
          ];

          nixosModules = exportModules [
            ./hosts/NotYourLaptop
            ./hosts/NotYourVM
            ./hosts/NotYourPC
          ];

          hosts = {
            NotYourLaptop.modules = with self.nixosModules; [ NotYourLaptop ];
            NotYourVM.modules = with self.nixosModules; [ NotYourVM ];
            NotYourPC.modules = with self.nixosModules; [ NotYourPC ];
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
