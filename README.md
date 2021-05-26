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
     - Direnv support!
   - Nightly Rust versions
   - Custom packages:
     - `xplr`: The hackable TUI File Explorer.
   - Deployment to Oracle Cloud NixOS Servers (with [deploy-rs](https://github.com/serokell/deploy-rs))
 - LaTeX editing with neovim side-by-side with Zathura
 - Many Rusty replacements and new tools! (`bat`, `hyperfine`, etc.)

### Cheatsheet

> Note: The following commands assume you are in the shell with direnv. If you are not and a command is not found, try entering the shell with `nix develop`, or run the command with `nix develop -c <command>`.

Show provided flakes:

```
nix flake show
```

Format/lint the project files with `nixpkgs-fmt`:

```
frmt
```

Unlock the crypt:

```
git crypt unlock /path/to/symmetric_key
```

Deploy to remote machine(s):

```
nix run github:serokell/deploy-rs
```

Update all inputs:

```
nix flake update
```

Update a specific input:

```
nix flake lock --update-input nixpkgs
```

### TODO

 - [ ] [Impermanence](https://github.com/nix-community/impermanence)

### Useful links

 - [David O'Toole Org Tutorial](https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html)

### Credits

A large thanks to:

 - [Terlar's nixfiles](https://github.com/terlar/nix-config) for the inspiration on how to modularize `home/`.
 - [Gytis Ivaskevicius' flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus) for inspiring my painless `flake.nix`
 - [DieracDelta](https://github.com/DieracDelta) and [Gytis Ivaskevicius](https://github.com/gytis-ivaskevicius) for the convincing pitch on "why Nix"

As well as the communities that always provide help in times of need.

<sup>1</sup> Laptop is on NixOS WSL.
