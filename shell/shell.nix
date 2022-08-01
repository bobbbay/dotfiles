{ pkgs, extraModulesPath, inputs, lib, ... }:
let
  inherit (pkgs)
    agenix
    cachix
    editorconfig-checker
    mdbook
    nixUnstable
    nixpkgs-fmt
    nvfetcher-bin
    ;

  pkgWithCategory = category: package: { inherit package category; };
  os = pkgWithCategory "os";
  linter = pkgWithCategory "linter";
  docs = pkgWithCategory "docs";
in
{
  _file = toString ./.;


  # tempfix: remove when merged https://github.com/numtide/devshell/pull/123
  devshell.startup.load_profiles = pkgs.lib.mkForce (pkgs.lib.noDepEntry ''
    # PATH is devshell's exorbitant privilige:
    # fence against its pollution
    _PATH=''${PATH}
    # Load installed profiles
    for file in "$DEVSHELL_DIR/etc/profile.d/"*.sh; do
      # If that folder doesn't exist, bash loves to return the whole glob
      [[ -f "$file" ]] && source "$file"
    done
    # Exert exorbitant privilige and leave no trace
    export PATH=''${_PATH}
    unset _PATH
  '');

  commands = [
    (os nixUnstable)
    (os agenix)

    {
      category = "os";
      name = nvfetcher-bin.pname;
      help = nvfetcher-bin.meta.description;
      command = "cd $PRJ_ROOT/pkgs; ${nvfetcher-bin}/bin/nvfetcher -c ./sources.toml $@";
    }

    (linter nixpkgs-fmt)
    (linter editorconfig-checker)

    (docs mdbook)
  ]
  ++ lib.optionals (!pkgs.stdenv.buildPlatform.isi686) [
    (os cachix)
  ]
  ++ lib.optionals (pkgs.stdenv.hostPlatform.isLinux && !pkgs.stdenv.buildPlatform.isDarwin) [
    (os inputs.nixos-generators.defaultPackage.${pkgs.system})
    (os inputs.deploy.packages.${pkgs.system}.deploy-rs)
  ]
  ;
}
