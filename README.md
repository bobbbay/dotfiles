## Dotfiles

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)



### Features

 - Nix declarative configurations
   - Flakes
   - Modules
   - Cachix
   - Private key protection with `git-crypt`
   - WSL NixOS config-ready
   - ["Erase Your Darlings"](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html)
   - `nix develop`: fully-featured dev shell
   - Nightly Rust versions
   - Custom packages:
     - `bobtools`: A custom set of aliases and shell scripts for ease-of-use.
     - `comma`: Run any command, without installing them!
     - `xplr`: The hackable TUI File Explorer.
   - Deployment to Oracle Cloud NixOS Servers (with [deploy-rs](https://github.com/serokell/deploy-rs))
 - LaTeX editing with neovim side-by-side with Zathura

### Usage

Show provided flakes:

```
nix flake show
```

> Note: you can use bin/nd instead of `nix develop -c ...`. The `nd` command will be available if you have installed this configuration.

Format/lint the project files with `nixfmt`:

```
nix develop -c lint
```

Unlock the crypt:

```
nix develop -c git crypt unlock /path/to/symmetric_key
```

Deploy to remote machine(s):

```
nix run github:serokell/deploy-rs
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

 - [ ] Re-write NotYourPC's "Erase Your Babies" to use [this nix-community project, impermanence](https://github.com/nix-community/impermanence), instead.
 - [ ] RPi 4 support (try: [nixos-generate](https://github.com/nix-community/nixos-generators))

### Credits

A large thanks to:

 - [Terlar's nixfiles](https://github.com/terlar/nix-config) for the inspiration on how to modularize `home/`.
 - [Gytis Ivaskevicius' flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus) for inspiring my painless `flake.nix`
 - [DieracDelta](https://github.com/DieracDelta) and [Gytis Ivaskevicius](https://github.com/gytis-ivaskevicius) for the convincing pitch on "why Nix"

As well as the communities that always provide help in times of need.

<sup>1</sup> Laptop is on NixOS WSL.
