{
  description = "Flake output selector using fzf";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-nix.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-nix.inputs.nixpkgs.follows = "nixpkgs";

    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
        ./check.nix
        ./devshell.nix
        ./fmt.nix
      ];
      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = { pkgs, self', ... }: {
        packages.flake-fzf = pkgs.callPackage ./default.nix { };
        packages.default = self'.packages.flake-fzf;

        overlayAttrs = self'.packages;
      };
    });
}
