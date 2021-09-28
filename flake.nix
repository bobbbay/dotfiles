{
  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    emacs.url = "github:nix-community/emacs-overlay";
    home.url = "github:nix-community/home-manager/release-21.05";

    fenix.url = "github:nix-community/fenix";
    deploy-rs.url = "github:serokell/deploy-rs";

    doom.url = "github:vlaci/nix-doom-emacs";
    neomacs.url = "/home/demo/projects/neomacs";
    neovim.url = "github:neovim/neovim?dir=contrib";
    # [TODO]: Use mainstream repository once merged. P.S. Thanks Kevin!
    kmonad.url = "github:pnotequalnp/kmonad/flake?dir=nix";
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
    , deploy-rs
    , doom
    , neomacs
    , neovim
    , kmonad
    , ...
    }:
      with builtins;
      utils.lib.systemFlake {
        inherit self inputs;

        supportedSystems = [ "x86_64-linux" ];

        channels.nixpkgs.input = nixpkgs;
        channelsConfig = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };

        modules = utils.lib.modulesFromList [
          ./modules/cachix.nix
          ./modules/media.nix
          ./modules/guacamole.nix
        ];

        sharedOverlays = [
          (import ./pkgs)
          (
            final: prev: {
              inherit (deploy-rs.packages.${prev.system}) deploy-rs;
              unstable = unstable.legacyPackages.${prev.system};
              neovim-nightly = neovim.defaultPackage.${prev.system};
            }
          )
          nur.overlay
          emacs.overlay
          fenix.overlay
        ];

        sharedModules = with self.modules; [
          cachix
          guacamole
          kmonad.nixosModule

          home.nixosModules.home-manager
          utils.nixosModules.saneFlakeDefaults
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ ./suites ./profiles ./modules/home ./programs doom.hmModule neomacs.hmModule ];
          }
        ];

        hosts = {
          NotYourPC.modules = with self.modules; [ ./host/NotYourPC ];
          NotYourLaptop.modules = with self.modules; [ ./host/NotYourLaptop ];
          NotYourVM.modules = with self.modules; [ ./host/NotYourVM ];
          NotYourServer.modules = with self.modules; [ ./host/NotYourServer ];
        };

        devShellBuilder = channels:
          with channels.nixpkgs;
          mkShell {
            buildInputs = [
              cachix
              nixpkgs-fmt
              nixos-generators
              git-crypt
              deploy-rs
            ];
          };

        deploy.nodes.oracleyServer = {
          hostname = (readFile ./crypt/oracleyServer.ip);
          profiles.main = {
            user = "root";
            sshUser = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.NotYourServer;
          };
        };

        checks = builtins.mapAttrs
          (system: deployLib: deployLib.deployChecks self.deploy)
          deploy-rs.lib;
      };
}
