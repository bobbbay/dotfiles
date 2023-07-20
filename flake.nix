{
  description = "Bobbbay's ~. Nix all the things!";

  inputs = {
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.home-manager.follows = "home";

    nixos.url = "github:nixos/nixpkgs/nixos-23.05";
    latest.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home.url = "github:nix-community/home-manager/release-23.05";
    home.inputs.nixpkgs.follows = "nixos";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixos";

    nvfetcher.url = "github:berberman/nvfetcher";
    nvfetcher.inputs.nixpkgs.follows = "nixos";

    doom.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = {
    self,
    digga,
    nixos,
    latest,
    nur,
    home,
    agenix,
    nvfetcher,
    doom,
    ...
  } @ inputs:
    digga.lib.mkFlake {
      inherit self inputs;

      channelsConfig = {allowUnfree = true;};

      channels.nixos = {};
      channels.latest = {};

      lib = import ./lib {lib = digga.lib // nixos.lib;};

      sharedOverlays = [
        (final: prev: {
          __dontExport = true;
          lib = prev.lib.extend (lfinal: lprev: {
            our = self.lib;
          });
        })

        nur.overlay
        # agenix.overlay
        # nvfetcher.overlay

        (import ./pkgs)
      ];

      nixos = {
        hostDefaults = {
          system = "x86_64-linux";
          channelName = "nixos";
          imports = [(digga.lib.importExportableModules ./modules)];
          modules = [
            {lib.our = self.lib;}
            digga.nixosModules.bootstrapIso
            digga.nixosModules.nixConfig
            home.nixosModules.home-manager
            agenix.nixosModules.age
          ];
        };

        imports = [(digga.lib.importHosts ./hosts/nixos)];

        hosts.NotYourLaptop = {};

        importables = rec {
          profiles =
            digga.lib.rakeLeaves ./profiles
            // {
              users = digga.lib.rakeLeaves ./users;
            };

          suites = with profiles; rec {
            base = [core.nixos users.bob users.root];
          };
        };
      };

      home = {
        imports = [(digga.lib.importExportableModules ./home/modules)];
        modules = [
          doom.hmModule
        ];
        importables = rec {
          profiles = digga.lib.rakeLeaves ./home/profiles;
          suites = with profiles; rec {
            base = [git gpg bash fonts];
            tools = [zoxide exa];
            development = [emacs];
            writing = [latex zathura];
            all = base ++ tools ++ development ++ writing;
          };
        };
        users = {
          bob = {suites, ...}: {
            imports = suites.all;
            home.stateVersion = "23.05";
          };
        };
      };

      homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

      devshell = ./shell;
    };

  nixConfig.extra-experimental-features = "nix-command flakes";
}
