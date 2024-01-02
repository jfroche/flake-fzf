# Nix Flake fzf

Stop trying to remember the exact name of the nix flake output you want to use !

This little script simplify flake output selection using [fzf](https://github.com/junegunn/fzf/).
We assume that you have nix configured with `nix-command` and `flake` available, add the following
to your `/etc/nix/nix.conf`:

```nix
experimental-features = nix-command flakes
```

## Running

In a directory containing a `flake.nix` file, run:

```bash
nix run github:jfroche/flake-fzf
```

It can also build remote flake if you provide a flake url:

```bash
nix run github:jfroche/flake-fzf github:Mic92/nix-ci-build
```

## Key bindings

Inside the fzf interface, you can use:

- `enter` to select or build the selected flake output
- `tab` to filter packages corresponding to your system
- `shift-tab` to filter nixos system configurations

## Parameters

`flake-fzf` accepts the following parameters:

- `--print` will print the selected flake output instead of building it. This is useful if you want to use it in a shell and remember the command line (see below).

## Usage

Select a flake output, then press `enter` to build it.

If you are using `zsh` here is a simple keybind to run it when pressing `ctrl-l`:

```zsh
bindkey -s "^L" 'nix run github:jfroche/flake-fzf^M'
```
If you want to keep the command line in your history, you can use this instead:

```zsh
bindkey -s "^L" 'print -z $(nix run github:jfroche/flake-fzf . --print)^M'
```

This will run the command and replace the command line with the selected flake output.

Of course if you installed flake-fzf in your PATH, you can use it directly:

```zsh
bindkey -s "^L" 'print -z $(flake-fzf . --print)^M'
```
