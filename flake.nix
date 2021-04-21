{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    home.url = "github:nix-community/home-manager/release-20.09";

    mozpkgs = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };

    flake-utils.url = "github:numtide/flake-utils";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = inputs@{ self, utils, home, nixpkgs, unstable, mozpkgs, nur, ... }:
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

      sharedOverlays = [ 
        nur.overlay
        (import mozpkgs)
      ];

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
    };
}
