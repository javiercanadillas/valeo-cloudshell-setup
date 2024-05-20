# Qwiklabs Cloud Shell setup

This repo contains a basic Cloud Shell setup for Qwiklabs for Valeo, including:

- Persistence settings for Qwiklabs so things like GCP Project ID, Region or installed packages are not lost upon Cloud Shell VM restarts
- Customized prompt for Git integration and long paths
- Some Cloud Shell Editor configurations (Dark Theme, tabs to 2 spaces...)
- C compilation toolchain
- Gemini Code Assist configuration

## Basic Setup

Open a new [Google Cloud Shell Editor](https://ide.cloud.google.com) in your Qwiklabs project. Once there:

1. click on "Cloud Code: Sign-in" in the left part of the bar that appears at the bottom of the IDE. Click Authorize if requested.
2. Open a new integrated terminal pane going to "Terminal > New Terminal" or pressing ``CTRL + ALT + ` `` (or ``CTRL + OPTION + ` `` if you're on a Mac).

In the terminal, set up your project, the labs will be assuming `europe-west1` as region:

```bash
export PROJECT_ID=<your qwiklabs project ID here>
```

Then, run the following Cloud Shell configuration script to get everything setup:

```bash
CS_SOURCE="https://raw.githubusercontent.com/javiercanadillas/valeo-cloudshell-setup/${GIT_BRANCH:-main}/setup_qw_cs"
bash <(curl -s "$CS_SOURCE") && exec $SHELL -l
```

If you just want to download the file first, make modifications and then run it, do the following:

```bash
# Download the file
CS_SETUP="setup_qw_cs"
CS_SOURCE="https://raw.githubusercontent.com/javiercanadillas/valeo-cloudshell-setup/${GIT_BRANCH:-main}/$CS_SETUP"
curl -s "$CS_SOURCE" -o "$HOME/$CS_SETUP"
# Now Make your modifications using your favorite editor
```

And once done, run it:

```bash
bash -x "$HOME/$CS_SETUP"
```

## Adding post script customizations

Add them to `~/.config/bash/custom_config.bash` and they will be sourced automatically at the end of the setup script.
