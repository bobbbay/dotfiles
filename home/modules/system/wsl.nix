{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.system.wsl;
in {
  options.system.wsl = {
    enable = mkEnableOption "WSL configuration.";
  };

  config = mkIf cfg.enable {
    programs.bash.bashrcExtra = ''
      export DISPLAY=$(ip route list default | awk '{print $3}'):0
    '';
  };
}
