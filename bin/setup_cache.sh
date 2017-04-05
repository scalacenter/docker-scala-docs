#!/usr/bin/env bash
set -eu

export IVY_CACHE="$HOME/.ivy2"
test -d "$IVY_CACHE" || \
  ln "$DRONE_DIR/.ivy2" "$IVY_CACHE" && \
  echo "Ivy cache has been set up: $IVY_CACHE."

export COURSIER_CACHE="$HOME/.coursier"
test -d "$COURSIER_CACHE" || \
  ln "$DRONE_DIR/.coursier" "$COURSIER_CACHE"  && \
  echo "Coursier cache context has been set up: $COURSIER_CACHE."
