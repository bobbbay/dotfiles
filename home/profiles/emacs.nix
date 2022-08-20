{pkgs, ...}: {
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = pkgs.callPackage ../config {};
  };

  services.emacs = {
    enable = true;
    client.enable = true;
  };
}
