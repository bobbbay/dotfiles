{ config, pkgs, lib, ... }:

with lib;
let cfg = config.cachix;
in {
  options = {
    cachix.enable = mkEnableOption "Enable custom cachix configuration";
  };

  config = mkIf cfg.enable {
    nix = {
      extraOptions = "gc-keep-outputs = true";

      binaryCaches = [
        "https://bobbbix.cachix.org"
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://vitality.cachix.org"
      ];
      binaryCachePublicKeys = [
        "bobbbix.cachix.org-1:h+zLVb0C2f5gMYz8yY07p71MNWMRuxCMipO5NLmurfA="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "vitality.cachix.org-1:3EQptE4KeHbpTzbu/O/K6wi6XdOJThVyvrPEGS47+bs="
      ];
    };
  };
}
