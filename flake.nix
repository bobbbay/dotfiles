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

    neovim.url = "github:neovim/neovim?dir=contrib";
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
    , neovim
    , doom
    , ...
    }:
      with builtins;
      utils.lib.systemFlake {
        inherit self inputs;

        supportedSystems = [ "x86_64-linux" ];

        channels.nixpkgs = { input = nixpkgs; };
        channelsConfig.allowUnfree = true;
        channelsConfig.allowUnsupportedSystem = true;

        hosts = {
          NotYourPC.modules = with self.modules; [ ./host/NotYourPC ];
          NotYourLaptop.modules = with self.modules; [ ./host/NotYourLaptop ];
          NotYourServer.modules = with self.modules; [ ./host/NotYourServer ];
        };

        modules = utils.lib.modulesFromList [
          ./modules/cachix.nix
          ./modules/home/emacs
        ];

        sharedOverlays = [
          (import ./pkgs)
          (final: prev: {
            inherit (deploy-rs.packages.${prev.system}) deploy-rs;
            unstable = unstable.legacyPackages.${prev.system};
            neovim-nightly = neovim.defaultPackage.${prev.system};
          })
          nur.overlay
          emacs.overlay
          fenix.overlay
        ];

        sharedModules = with self.modules; [
          cachix

          home.nixosModules.home-manager
          utils.nixosModules.saneFlakeDefaults
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
        ];

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
