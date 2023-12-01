#!/usr/bin/env bash
set -euo pipefail
system=$(nix-instantiate --eval --expr 'builtins.currentSystem' --json | jq -r)
flakePath="${1:-.}"
selection=$(
  nix flake show --json "$flakePath" 2> /dev/null | jq -r '
  [
    paths(scalars) as $path |
    {"key": $path | join("."), "value": getpath($path)} | 
    select( .key | endswith("type")) |
    select(.value != "unknown") 
  ] |
  map({ "key": "\(.key | sub(".type"; ""))", "value": .value}) |
  from_entries |
  to_entries[] |
  [.key, .value] |
  @tsv' \
        | fzf --layout=reverse --border \
      --preview "nix show-derivation ${flakePath}#{1} 2>/dev/null" \
      --delimiter "\t" --padding=1 \
      --bind 'btab:change-query(configuration )' \
      --bind "tab:change-query($system )"
)

selectedPath="$(echo -n "$selection" | cut -d$'\t' -f1 | tr -d '\n')"
selectedType="$(echo -n "$selection" | cut -d$'\t' -f2 | tr -d '\n')"
case $selectedType in
  "nixos-configuration")
    set -x
    nix build -L "${flakePath}#$selectedPath.config.system.build.toplevel"
    ;;
  *)
    set -x
    nix build -L "${flakePath}#$selectedPath"
    ;;
esac
