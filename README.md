# Flake fzf

Stop trying to remember the exact name of the flake output you want to use !

This little script simplify flake output selection using [fzf](https://github.com/junegunn/fzf/).

## Running

```bash
nix run github:jfroche/flake-fzf
```

## Usage

Select a flake output using fzf, then press `enter` to build it.

Use `tab` in fzf to filter packages corresponding to your system configuration, then `enter` to build it.

Use `shift-tab` in fzf to filter nixos system configurations, then `enter` to build one of them.
