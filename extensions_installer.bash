#!/bin/false
# shellcheck shell=bash
# shellcheck disable=SC2317

# Install Code OSS extensions
code_oss_extensions_setup() {
  _info "Installing Code OSS extensions..."
  command -v codeoss 2>/dev/null 1>&2 || {
    _error "Code OSS not found"
    exit 1
  }
  declare -g code_oss_extensions_list=(
    "timonwong.shellcheck"
    "zhuangtongfa.material-theme"
    "ms-vscode.cpptools-extension-pack"
    "mhutchie.git-graph"
    "davidanson.vscode-markdownlint"
  )

  for extension in "${code_oss_extensions_list[@]}"; do
    codeoss --install-extension "$extension" || _error "Couldn't install extension"
  done
}

main() {
  code_oss_extensions_setup
}

main "$@"
