{suites, ...}: {
  imports = suites.base;

  environment.noXlibs = true;

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "bob";
    startMenuLaunchers = true;
    interop.register = false;
  };
}
