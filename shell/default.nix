{
  self,
  inputs,
  ...
}: {
  modules = with inputs; [];
  exportedModules = [
    ./shell.nix
  ];
}
