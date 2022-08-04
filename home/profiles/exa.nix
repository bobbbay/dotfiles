{
  programs.exa = {
    enable = true;
  };

  programs.bash.shellAliases = {
    ls = "exa --long --icons --header --git --links --grid";
  };
}
