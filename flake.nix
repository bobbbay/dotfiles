{
  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home.url = "github:nix-community/home-manager/release-20.09";

    fenix.url = "github:nix-community/fenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    doom.url = "github:vlaci/nix-doom-emacs";
  };

  outputs = inputs@{ self, utils, nixpkgs, unstable, nur, home, fenix, deploy-rs
    , doom, ... }:
    with builtins;
    let pkgs = self.pkgs.x86_64-linux.nixpkgs;
    in utils.lib.systemFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];

      channels.nixpkgs = {
        input = nixpkgs;
        config = {
          allowUnfree = true;
          allowUnsupportedSystem = true;
        };
      };

      hosts = {
        NotYourPC.modules = [ (import ./host/NotYourPC.nix) ];
        NotYourLaptop.modules = [
          (import ./host/NotYourLaptop.nix)
          ({ pkgs, config, ... }: {
            home-manager.users.bobbbay = {
              imports = [ doom.hmModule ./suites/full ];
            };
          })
        ];
        NotYourServer.modules = [
          (import ./host/NotYourServer.nix)
          ({ pkgs, config, ... }: {
            home-manager.users.main = { imports = [ ./suites/minimal ]; };
          })
        ];
      };

      sharedOverlays = [
        (import ./pkgs)
        (final: prev: { unstable = unstable.legacyPackages.${prev.system}; })
        nur.overlay
        fenix.overlay
      ];

      sharedModules = [
        home.nixosModules.home-manager
        utils.nixosModules.saneFlakeDefaults
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];

      devShellBuilder = channels:
        with channels.nixpkgs.pkgs;
        with (import ./lib/devshell.nix { inherit pkgs; });
        mkShell {
          buildInputs = [
            cachix
            fd
            nixfmt
            nixos-generators
            git-crypt

            lint
          ];
        };

      deploy.nodes.oracleyServer = {
        hostname = "193.123.67.110";
        profiles.main = {
          user = "root";
          sshUser = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos
            self.nixosConfigurations.NotYourServer;
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
