{ config, pkgs, ... }:

{
  user.name = "bob";

  modules = {
    cachix.enable = true;

    dev = {
      editors = {
        # neomacs.enable = true;
        # TODO neovitality.enable = true;
      };

      tools = {
        git.enable = true;
        direnv.enable = true;
        gpg.enable = true;
        ssh.enable = true;
      };

      # TODO Separate these into their own modules.
      extra.enable = true;
    };

    desktop = {
      term = {
        bash.enable = true;
        extra.enable = true;
      };

      apps = {
        extra.enable = true;
        fonts.enable = true;
      };
    };
  };

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "bob";
    startMenuLaunchers = true;
  };
}
