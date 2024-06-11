#!/bin/false
# shellcheck shell=bash
# shellcheck disable=SC2317

# Make sure codeoss alias is expanded
shopt -s expand_aliases

# Legacy editor setup
theia_editor_setup() {
  _info "Setting up Theia basic configuration..."
  local -r theia_config_dir="$HOME/.theia"
  # Theia dir may not exist if Theia hasn't been launched yet for the first time
  [[ -d "$theia_config_dir" ]] || {
    mkdir -p "$theia_config_dir"
    cat <<EOF > "$theia_config_dir/settings.json"
{}
EOF
  }
  # Add basic configuration to Theia
  jq '. += {
            "workbench.colorTheme": "Default Dark+",
            "editor.tabSize": 2,
            "editor.fontSize": 14,
            "terminal.integrated.fontSize": 14
            }' "$theia_config_dir/settings.json" > "$theia_config_dir/settings.json.enhanced"
  cp -- "$theia_config_dir/settings.json"{,.backup}
  cp -- "$theia_config_dir/settings.json"{.enhanced,}
}

# Check if Code OSS is properly referenced
check_codeoss() {
  code_oss_loc="/google/devshell/editor/code-oss-for-cloud-shell/bin/remote-cli/codeoss"
  # Make sure Code OSS is properly located
  command -v codeoss 2>/dev/null 1>&2 || {
    #shellcheck disable=SC2139
    alias codeoss="$code_oss_loc"
  }
}

# Install Code OSS extensions
code_oss_extensions_setup() {
  local -r codeoss_extensions_installer="$CONFIG_DIR/${FILE_NAMES[extensions_installer]}"
  [[ -f $codeoss_extensions_installer ]] && {
    #shellcheck disable=SC1090
    source "$codeoss_extensions_installer" && touch /tmp/extensions_setup_done
  }
}

# Install Code OSS basic configuration
code_oss_main_setup() {
  _info "Setting up Code OSS basic configuration..."
  codeoss_settings_dest="$HOME/.codeoss/data/Machine/settings.json"
  # shellcheck disable=SC2154
  envsubst < "$CONFIG_DIR/${FILE_NAMES[codeoss_settings]}" > "${codeoss_settings_dest}"
}

customize_bat() {
  _info "Customizing bat..."
  hash batcat && {
    local -r batcatconfdir="$HOME/.config/bat"
    mkdir -p "$batcatconfdir" || _error "Cannot create $batcatconfdir"
    cat <<EOF > "$batcatconfdir/config"
#Set the theme to "base16"
--theme="base16"
EOF
  }
}

main() {
  theia_editor_setup
  check_codeoss
  code_oss_extensions_setup
  code_oss_main_setup
}

main "$@"
