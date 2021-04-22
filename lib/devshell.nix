{ pkgs }:

with pkgs;

{
  switchNixos = writeShellScriptBin "switch-nixos" ''
    set -euo pipefail
    sudo nixos-rebuild switch --flake . $@
  '';

  switchHome = writeShellScriptBin "switch-home" ''
    set -euo pipefail
    export PATH=${lib.makeBinPath [ gitMinimal hostname jq nixUnstable ]}
    user="''${1:-$USER}"
    host="$(hostname)"

    1>&2 echo "Switching Home Manager configuration for: $user"

    configExists() {
      nix eval --json .#homeManagerConfigurations --apply "x: (builtins.any (n: n == \"$config\") (builtins.attrNames x))" 2>/dev/null
    }

    config="$user@$host"
    [ "$(configExists)" = "true" ] || config="$user"

    if [ "$(configExists)" != "true" ]; then
      1>&2 echo "No configuration found, aborting..."
      exit 1
    fi

    1>&2 echo "Building configuration $config..."
    out="$(nix build --json ".#homeManagerConfigurations.\"$config\".activationPackage" | jq -r .[].outputs.out)"
    1>&2 echo "Activating configuration..."
    "$out"/activate
  '';

  useCaches = writeShellScriptBin "use-caches" ''
    cachix use -O . nix-community
    cachix use -O . bobbbix
  '';

  lint = writeShellScriptBin "lint" ''
    set -euo pipefail
    fd --color=never .nix | xargs nixfmt
  '';
}
