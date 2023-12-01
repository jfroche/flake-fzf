{ writeShellApplication, fzf, bash, jq, bat }:
writeShellApplication {
  name = "flake-fzf";
  runtimeInputs = [ fzf bash jq bat ];
  text = ''bash ${./flake-fzf.sh} "$@"'';
}
