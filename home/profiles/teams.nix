{ pkgs, ... }: {
  home.packages = with pkgs; [
    teams
  ];
}
