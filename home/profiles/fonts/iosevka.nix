{pkgs, ...}: {
  home.packages = with pkgs; [
    (
      nerdfonts.override {
        fonts = ["Iosevka"];
      }
    )
  ];

  fonts.fontconfig.enable = true;
}
