{pkgs, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      return {
          color_scheme = "nightfox"
      }
    '';
  };
}
