#!/usr/bin/env bash
set -eo pipefail

INSTALL_PREFIX="${INSTALL_PREFIX:-"$HOME/.local"}"

XDG_DATA_HOME="${XDG_DATA_HOME:-"$HOME/.local/share"}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-"$HOME/.cache"}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-"$HOME/.config"}"

DARKVIM_RUNTIME_DIR="${DARKVIM_RUNTIME_DIR:-"$XDG_DATA_HOME/darkvim"}"
DARKVIM_CONFIG_DIR="${DARKVIM_CONFIG_DIR:-"$XDG_CONFIG_HOME/dark"}"
DARKVIM_CACHE_DIR="${DARKVIM_CACHE_DIR:-"$XDG_CACHE_HOME/dark"}"

DARKVIM_BASE_DIR="${DARKVIM_BASE_DIR:-"$DARKVIM_RUNTIME_DIR/dark"}"

function setup_shim() {
  local src="$DARKVIM_BASE_DIR/utils/bin/dark.template"
  local dst="$INSTALL_PREFIX/bin/dark"

  [ ! -d "$INSTALL_PREFIX/bin" ] && mkdir -p "$INSTALL_PREFIX/bin"

  # remove outdated installation so that `cp` doesn't complain
  rm -f "$dst"

  cp "$src" "$dst"

  sed -e s"#RUNTIME_DIR_VAR#\"${DARKVIM_RUNTIME_DIR}\"#"g \
    -e s"#CONFIG_DIR_VAR#\"${DARKVIM_CONFIG_DIR}\"#"g \
    -e s"#CACHE_DIR_VAR#\"${DARKVIM_CACHE_DIR}\"#"g "$src" \
    | tee "$dst" >/dev/null

  chmod u+x "$dst"
}

setup_shim "$@"

echo "You can start DarkVim by running: $INSTALL_PREFIX/bin/dark"
