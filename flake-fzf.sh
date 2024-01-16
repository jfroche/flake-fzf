#!/usr/bin/env bash
set -euo pipefail
if [[ ${2:-} == "--print" ]]; then
  MODE="print"
else
  MODE="eval"
fi

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
      --preview "nix derivation show ${flakePath}#{1} 2>/dev/null | bat -f -l json" \
      --delimiter "\t" --padding=1 \
      --bind 'btab:change-query(configuration )' \
      --bind "tab:change-query($system )"
)

selectedPath="$(echo -n "$selection" | cut -d$'\t' -f1 | tr -d '\n')"
selectedType="$(echo -n "$selection" | cut -d$'\t' -f2 | tr -d '\n')"

case $selectedPath in
  devShells.*)
    selectedType="devShell"
    ;;
  formatter.*)
    selectedType="formatter"
    ;;
  templates.*)
    selectedType="template"
    ;;
esac

case $selectedType in
  "nixos-configuration")
    installable="${flakePath}#$selectedPath.config.system.build.toplevel"
    subcommand="build"
    ;;
  "app" | "formatter")
    installable="${flakePath}#$selectedPath"
    subcommand="run"
    ;;
  "devShell")
    installable="${flakePath}#$selectedPath"
    subcommand="develop"
    ;;
  "template")
    installable="${flakePath}#$selectedPath"
    subcommand="flake init -t"
    ;;
  *)
    installable="${flakePath}#$selectedPath"
    subcommand="build"
    ;;
esac

if [[ $MODE == "print" ]]; then
  echo "nix $subcommand -L $installable"
else
  nix "$subcommand" -L "$installable"
fi
