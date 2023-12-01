{ writeShellApplication, fzf, bash, jq }:
writeShellApplication {
  name = "flake-fzf";
  runtimeInputs = [ fzf bash jq ];
  text = ''bash ${./flake-fzf.sh} "$@"'';
}
