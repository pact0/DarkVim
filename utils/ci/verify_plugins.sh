#!/usr/bin/env bash
set -e

BASEDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BASEDIR="$(dirname -- "$(dirname -- "$BASEDIR")")"

DARKVIM_BASE_DIR="${DARKVIM_BASE_DIR:-"$BASEDIR"}"

dark --headless \
  -c "luafile ${DARKVIM_BASE_DIR}/utils/ci/verify_plugins.lua"
