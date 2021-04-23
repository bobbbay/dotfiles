## Dotfiles

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

This is my NixOS configuration for my desktop as well as my laptop<sup>1</sup>.

### Usage

Show provided flakes:

```
nix flake show
```

> Note: you can use bin/nd instead of `nix develop -c ...`. The `nd` command will be available if you have installed this configuration.

Switch both system and home:

```
nix develop -c switch-nixos
```

Switch home only:

```
nix develop -c switch-home
```

Format/lint the project files with `nixfmt`:

```
nix develop -c lint
```

Use cachix caches:

```
nix develop -c use-caches
```

Unlock the crypt:

```
nix develop -c git crypt unlock /path/to/symmetric_key
```

Update all inputs:

```
nix flake update --recreate-lock-file --commit-lock-file
```

Update a specific input:

```
nix flake update --update-input nixpkgs --commit-lock-file
```

### TODO

 - [ ] Set up ssh keys to be declarative (try: SOPS?)
 - [ ] Create a list of what this config provides, potentially based off of Terlar's configs.
 - [ ] Go through `lib/devshell.nix` and check if there are any unneeded commands/broken commands in there.
 - [ ] Flake `pkgs/` - see Devos
 - [ ] Re-write NotYourPC's "Erase Your Babies" to use [this nix-community project, impermanence](https://github.com/nix-community/impermanence), instead.

### Credits

A large thanks to:

 - [Terlar's nixfiles](https://github.com/terlar/nix-config) for the inspiration on how to modularize `home/`.
 - [Gytis Ivaskevicius' flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus) for inspiring my painless `flake.nix`
 - [DieracDelta](https://github.com/DieracDelta) and [Gytis Ivaskevicius](https://github.com/gytis-ivaskevicius) for the convincing pitch on "why Nix"

As well as the communities that always provide help in times of need.

<sup>1</sup> Laptop is on NixOS WSL.
