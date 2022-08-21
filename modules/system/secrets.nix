{
  config,
  lib,
  pkgs,
  ...
}: {
  config.age.secrets = {
    pragmatapro.file = ../../secrets/fonts/pragmata-pro-mono-liga.age;
  };
}
