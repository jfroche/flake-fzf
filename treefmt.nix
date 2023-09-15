{ lib, inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
  ];

  perSystem = { pkgs, ... }: {
    treefmt = {
      # Used to find the project root
      projectRootFile = "flake.lock";

      settings.formatter = {
        shellcheck = {
          command = "sh";
          options = [
            "-eucx"
            ''
              # First shellcheck
              ${lib.getExe pkgs.shellcheck} --format=diff "$@"
              # Then shfmt
              ${lib.getExe pkgs.shfmt} -i 2 -ci -bn -sr -kp -s -d "$@"
            ''
            "--"
          ];
          includes = [ "*.sh" ];
        };
        nix = {
          command = "sh";
          options = [
            "-eucx"
            ''
              # First deadnix
              ${lib.getExe pkgs.deadnix} --edit "$@"
              # Then nixpkgs-fmt
              ${lib.getExe pkgs.nixpkgs-fmt} "$@"
            ''
            "--"
          ];
          includes = [ "*.nix" ];
        };
      };
    };
  };
}
