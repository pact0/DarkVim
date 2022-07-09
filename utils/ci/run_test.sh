#!/usr/bin/env bash
set -e

export DARKVIM_RUNTIME_DIR="${DARKVIM_RUNTIME_DIR:-"$HOME/.local/share/darkvim"}"

export DARK_TEST_ENV=true

# we should start with an empty configuration
DARKVIM_CONFIG_DIR="$(mktemp -d)"
DARKVIM_CACHE_DIR="$(mktemp -d)"

export DARKVIM_CONFIG_DIR DARKVIM_CACHE_DIR

echo "cache: $DARKVIM_CACHE_DIR

config: $DARKVIM_CONFIG_DIR"

dark() {
  nvim -u "$DARKVIM_RUNTIME_DIR/dark/tests/minimal_init.lua" --cmd "set runtimepath+=$DARKVIM_RUNTIME_DIR/dark" "$@"
}

if [ -n "$1" ]; then
  dark --headless -c "lua require('plenary.busted').run('$1')"
else
  dark --headless -c "PlenaryBustedDirectory tests/specs { minimal_init = './tests/minimal_init.lua' }"
fi
