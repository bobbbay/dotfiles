{
  inputs = {
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home.url = "github:nix-community/home-manager/release-20.09";

    fenix.url = "github:nix-community/fenix";
  };

  outputs = inputs@{ self, utils, nixpkgs, unstable, nur, home, fenix, ... }:
    with builtins;
    let pkgs = self.pkgs.x86_64-linux.nixpkgs;
    in utils.lib.systemFlake {
      inherit self inputs;

      supportedSystems = [ "x86_64-linux" ];
      defaultSystem = "x86_64-linux";

      channels.nixpkgs = {
        input = nixpkgs;
        config = { allowUnfree = true; };
      };

      nixosProfiles = {
        NotYourPC = {
          nixpkgs = pkgs;
          modules = [ (import ./host/NotYourPC.nix) ];
        };
        NotYourLaptop = {
          nixpkgs = pkgs;
          modules = [
            (import ./host/NotYourLaptop.nix)
            ({ pkgs, config, ... }: {
              home-manager.users.bobbbay = {
                imports = [ ./profiles/cli ./profiles/dev ];
              };
            })
          ];
        };
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
    };
}
