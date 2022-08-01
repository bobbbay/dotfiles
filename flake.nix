{
  description = "Bobbbay's ~. Nix all the things!";

  inputs = {
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.home-manager.follows = "home";

    nixos.url = "github:nixos/nixpkgs/nixos-22.05";
    latest.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home.url = "github:nix-community/home-manager/release-22.05";
    home.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixos";

    wsl.url = "github:nix-community/NixOS-WSL";
    wsl.inputs.nixpkgs.follows = "nixos";
  };

  outputs =
    { self
    , digga
    , nixos
    , latest
    , nur
    , home
    , agenix
    , nvfetcher
    , wsl
    , ... } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = { allowUnfree = true; };

      channels.nixos = { };
      channels.latest = { };

      lib = import ./lib { lib = digga.lib // nixos.lib; };

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })

        nur.overlay
        agenix.overlay
        nvfetcher.overlay

        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [ (digga.lib.importExportableModules ./modules) ];
          modules = [
            { lib.our = self.lib; }
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            wsl.nixosModules.wsl
            agenix.nixosModules.age
          ];
        };

        imports = [ (digga.lib.importHosts ./hosts/nixos) ];

        hosts.NotYourLaptop = { };

        importables = rec {
          profiles = digga.lib.rakeLeaves ./profiles // {
            users = digga.lib.rakeLeaves ./users;
          };

          suites = with profiles; rec {
            base = [ core.nixos users.bob users.root ];
          };
        };
      };

      home = {
        imports = [ (digga.lib.importExportableModules ./users/modules) ];
        modules = [ ];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./users/profiles;
          suites = with profiles; rec {
            base = [ git ];
          };
        };
        users = {
          bob = { suites, ... }: { imports = suites.base; };
        };
      };

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      devshell = ./shell.nix;
    };

  nixConfig.extra-experimental-features = "nix-command flakes";
}
