#!/usr/bin/env bash
set -eo pipefail

ARGS_REMOVE_BACKUPS=0

declare -r XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
declare -r XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
declare -r XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

declare -r DARKVIM_RUNTIME_DIR="${DARKVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/darkvim"}"
declare -r DARKVIM_CONFIG_DIR="${DARKVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/dark"}"
declare -r DARKVIM_CACHE_DIR="${DARKVIM_CACHE_DIR:-"$XDG_CACHE_HOME/dark"}"

declare -a __dark_dirs=(
  "$DARKVIM_CONFIG_DIR"
  "$DARKVIM_RUNTIME_DIR"
  "$DARKVIM_CACHE_DIR"
)

function usage() {
  echo "Usage: uninstall.sh [<options>]"
  echo ""
  echo "Options:"
  echo "    -h, --help                       Print this help message"
  echo "    --remove-backups                 Remove old backup folders as well"
}

function parse_arguments() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --remove-backups)
        ARGS_REMOVE_BACKUPS=1
        ;;
      -h | --help)
        usage
        exit 0
        ;;
    esac
    shift
  done
}

function remove_dark_dirs() {
  for dir in "${__dark_dirs[@]}"; do
    rm -rf "$dir"
    if [ "$ARGS_REMOVE_BACKUPS" -eq 1 ]; then
      rm -rf "$dir.{bak,old}"
    fi
  done
}

function remove_dark_bin() {
  local legacy_bin="/usr/local/bin/dark "
  if [ -x "$legacy_bin" ]; then
    echo "Error! Unable to remove $legacy_bin without elevation. Please remove manually."
    exit 1
  fi

  dark_bin="$(command -v dark 2>/dev/null)"
  rm -f "$dark_bin"
}

function main() {
  parse_arguments "$@"
  echo "Removing DarkVim binary..."
  remove_dark_bin
  echo "Removing DarkVim directories..."
  remove_dark_dirs
  echo "Uninstalled DarkVim!"
}

main "$@"
