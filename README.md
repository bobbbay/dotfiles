## Dotfiles

This is my NixOS configuration for my desktop as well as my laptop<sup>1</sup>.

### TODO

 - [ ] Set up cachix and create builds upon push to GitHub
 - [ ] Set up ssh keys to be declarative (try: SOPS?)
 - [ ] Read through [terlar's configs](https://github.com/terlar/nix-config) and take inspiration ~~basically steal~~ from his `nix` command bindings.
 - [ ] Add the `xplr` package

### Credits

A large thanks to:

 - [Terlar's nixfiles]() for the inspiration on how to modularize `home/`.
 - [Gytis Ivaskevicius' flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus) for inspiring my painless `flake.nix`
 - [DieracDelta](https://github.com/DieracDelta) and [Gytis Ivaskevicius](https://github.com/gytis-ivaskevicius) for the convincing pitch on "why Nix"

As well as the communities that always provide help in times of need.

<sub>1</sub> Laptop is on NixOS WSL.
