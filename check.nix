{ inputs, ... }: {
  imports = [
    inputs.pre-commit-nix.flakeModule
  ];

  perSystem = { ... }: {
    pre-commit = {
      settings = {
        hooks.nil.enable = true;
      };
    };
  };
}
