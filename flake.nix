{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home.url = "github:nix-community/home-manager/release-20.09";

    mozpkgs = {
      url = "github:mozilla/nixpkgs-mozilla";
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = inputs@{ self, utils, home, nixpkgs, unstable, mozpkgs, nur, ... }:
    with builtins;
    let pkgs = self.pkgs.x86_64-linux.nixpkgs;
    in utils.lib.systemFlake {
      inherit self inputs;

      defaultSystem = "x86_64-linux";
      channels.nixpkgs = { input = nixpkgs; };
      channels.unstable.input = unstable;
      channelsConfig = { allowUnfree = true; };

      nixosProfiles = {
        NotYourPC = {
          nixpkgs = pkgs;
          modules = [ (import ./host/NotYourPC.nix) ];
        };
        NotYourLaptop = {
          nixpkgs = pkgs;
          modules = [ (import ./host/NotYourLaptop.nix) ];
        };
      };

      sharedOverlays = [ nur.overlay (import mozpkgs) self.overlay ];

      overlay = import ./pkgs;

      sharedModules = with self.nixosModules; [
        home.nixosModules.home-manager
        utils.nixosModules.saneFlakeDefaults
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.bobbbay = import ./home/users/bobbbay.nix;
        }
      ];

      nixosModules = utils.lib.modulesFromList [ ];

      devshellScripts = import ./lib/devshell.nix { inherit pkgs; };
      devShellBuilder = channels:
        with channels.nixpkgs.pkgs;
        with self.devshellScripts;
        mkShell {
          buildInputs =
            [ cachix fd nixfmt git-crypt switchHome switchNixos useCaches lint ];
        };
    };
}
