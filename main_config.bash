#!/bin/false
# shellcheck shell=bash
## main_config.bash: This script is intended to be sourced, it can be run in the event the Cloud Shell VM stops after a period
## of inactivity, and it will restore the necessary installed software and environment variables to its desired
## state

# DO NOT MODIFY THIS FILE - Change $HOME/.config/bash/custom_config.bash instead

# Expand directories to avoid escaping of $ signs in variables
shopt -s direxpand

# Add dirs to PATH properly
pathadd() {
    PATH=:$PATH
    PATH=$1${PATH//:$1:/:}
}

## Set desired environment variables
export CLOUDSDK_CONFIG="$HOME/.config/gcloud"
gcloud config configurations activate default --quiet --no-user-output-enabled
export CLOUDSDK_CONFIG
export PROJECT_ID
PROJECT_ID=$(gcloud config get-value project)
export PROJECT_ID
REGION=$(gcloud config get-value compute/region)
export REGION

# Enable kubectl autocompletion and use kubectl alias
#shellcheck disable=SC1090
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k

# Set path for extra binaries and scripts
[[ -d "$HOME/.local/bin" ]] && pathadd "$HOME/.local/bin"

# Other aliases
alias code='cloudshell edit'
alias gconf='gcloud config configurations'
alias bat='batcat'

# Grant access to codeoss in case it's not available
command -v codeoss >/dev/null 2>&1 || {
    ln -s "/google/devshell/editor/code-oss-for-cloud-shell/bin/remote-cli/codeoss" "$HOME/.local/bin/codeoss"
}

# Pyenv
hash pyenv 2>/dev/null 1>&2 && {
    export PYENV_ROOT="$HOME/.pyenv"
    #[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    [[ -d $PYENV_ROOT/bin ]] && pathadd "$PYENV_ROOT/bin"
    hash pyenv 2>/dev/null 1>&2 && eval "$(pyenv init -)"
}

# Custom functions
# Clean up the exercise directory
clean_work() {
  echo "Cleaning up \$WORKDIR/exercise..."
  read -p "Are you sure you want to continue? (y/n) " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf "$WORKDIR/exercise"
  fi
  pusd "$WORKDIR" || exit 1
  gsutil cp "gs://${PROJECT_ID}-exercise/exercise.zip" . && unzip exercise.zip && rm exercise.zip
  popd || exit 1
}

# Get solution
get_solution() {
  echo "Getting solution..."
  local -r solution_name="solution" && shift
  pushd "$WORKDIR" > /dev/null 2>&1 || exit 1
  gsutil cp "gs://${PROJECT_ID}-${solution_name}/${solution_name}.zip" . && unzip "${solution_name}.zip" && rm "${solution_name}.zip"
  echo "Now you can test the solution by performing these steps\
  - Go to the \"\$WORKDIR/solution\" directory\
  - Run \`make clean\`
  - Run \`make\`
  The solution will be built and you can test it by running the \`.hex\` file \
  that will be present in the \"\$WORKDIR/solution/bin\" directory."
  popd > /dev/null 2>&1 || exit  1  
}

# Get milestone 1
get_hint() {
  echo "Getting hint..."
  mkdir -p "$WORKDIR/hints"
  hint_name="$1" && shift
  pushd "$WORKDIR/hints" > /dev/null 2>&1 || exit 1
  gsutil cp "gs://${PROJECT_ID}-hints/${hint_name}.zip" . && unzip "${hint_name}.zip" && rm "${hint_name}.zip"
  popd > /dev/null 2>&1 || exit 1
}

# Include prompt
#shellcheck source=/dev/null
source "$HOME/.config/bash/prompt.bash"

# Source extra customizations
#shellcheck source=/dev/null
source "$HOME/.config/bash/custom_config.bash"