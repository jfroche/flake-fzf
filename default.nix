{ writeShellApplication, fzf, bash }:
writeShellApplication {
  name = "flake-fzf";
  runtimeInputs = [ fzf bash ];
  text = ''bash ${./flake-fzf.sh}'';
}
