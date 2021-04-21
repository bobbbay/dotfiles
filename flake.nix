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
    let pkgs = self.pkgs.nixpkgs;
    in utils.lib.systemFlake {
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
          home-manager.users.bobbbay = import ./home/users/bobbbay.nix;
        }
      ];

      nixosModules = utils.lib.modulesFromList [ ];
    };
}
