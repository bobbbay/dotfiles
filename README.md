## Dotfiles

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

### Features

 - Nix: 
   - Flakes
   - Modules
   - Cachix
   - `nix develop`: fully-featured dev shell
 - Private key protection with `git-crypt`
 - Nightly Rust versions
 - Deployment to Oracle Cloud NixOS Servers (with [deploy-rs](https://github.com/serokell/deploy-rs))
 - Emacs configuration
 - AwesomeWM Nord theme
 - And much more!
 

### Cheatsheet

> Note: The following commands assume you are in the shell with direnv. If you are not and a command is not found, try entering the shell with `nix develop`, or run the command with `nix develop -c <command>`.

Show provided flakes:

```
nix flake show
```

Format/lint the project files with `nixpkgs-fmt`:

```
dude fmt
```

Unlock the crypt:

```
dude unlock /path/to/symmetric_key
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

### What the `.org`?

> Wait a minute... You say you have AwesomeWM configurations, but where's your .lua? You say you have Emacs configurations, but where's the .el? 

Fear not! My configurations are documented in `org-mode` files, like [so](https://github.com/Bobbbay/dotfiles/blob/master/config/emacs.org), and tangled into system configurations during compile time with Nix, like [so](https://github.com/Bobbbay/dotfiles/blob/master/modules/home/emacs.nix#L30). This allows me to document my configuration with org-mode, and even compile them into a fully-featured documented webpage!

### Dude!

![dude](https://upload.wikimedia.org/wikipedia/en/thumb/f/ff/SuccessKid.jpg/256px-SuccessKid.jpg)

`dude` is a program I made to make managing my system configuration easier. To check out what dude does, run `d`:

```
Options:
      switch | s: run nixos-rebuild switch
      fmt | f: run nixpkgs-fmt on all Nix files in this directory
      update | up: run nix flake update
      upgrade | ug: run nix flake update, then rebuild
      unlock | u </path/to/symmetrical/key>: unlock the git crypt using the provided symmetrical key
```

### Useful links
 
#### Nix

 - [Gytis Ivaskevicius' flake-utils-plus](https://github.com/gytis-ivaskevicius/flake-utils-plus)
 - [Terlar's nixfiles](https://github.com/terlar/nix-config) for the inspiration on how to modularize his `home/`.
 - [Chris Warbo's "Useful Nix Hacks"](http://chriswarbo.net/projects/nixos/useful_hacks.html)

#### Emacs

 - [David O'Toole Org Tutorial](https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html)
 - ["Advanced Emacs" but not really advanced](https://www.cs.cmu.edu/~15131/f17/topics/extratations/advanced-emacs.pdf)
 - [Will Bush's beautiful template emacs.nix](https://github.com/willbush/system/blob/0c1aadad079f3c484a98bb43ca51f0f9eac44dc4/users/profiles/emacs.nix)
 - [rememberYou's .emacs.d](https://github.com/rememberYou/.emacs.d) and usual r/emacs TIP of the week posts

#### Miscellaneous

 - [Sridhar's Apps](https://notes.srid.ca/apps)
