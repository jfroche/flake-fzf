{ inputs, ... }: {
  imports = [
    inputs.devshell.flakeModule
  ];

  perSystem = { config, ... }: {
    devshells.default = {
      commands = [
        {
          name = "fmt";
          category = "linting";
          help = "Format code";
          command = ''
            nix fmt -L
          '';
        }
      ];
      devshell.startup.pre-commit.text = config.pre-commit.installationScript;
    };
  };
}
