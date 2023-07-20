{suites, ...}: {
  imports = suites.base ++ [ ./configuration.nix ];

  system.stateVersion = "23.05";
}
