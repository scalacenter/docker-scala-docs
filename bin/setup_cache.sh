#!/usr/bin/env bash
set -eu

export IVY_CACHE="$HOME/.ivy2"
test -d "$IVY_CACHE" || \
  ln "$IVY_CACHE" "$DRONE_DIR/.ivy2" && \
  echo "Ivy cache has been set up: $IVY_CACHE."

export COURSIER_CACHE="$DRONE_DIR/.coursier"
test -d "$COURSIER_CACHE" || \
  ln "$COURSIER_CACHE" "$DRONE_DIR/.coursier"  && \
  echo "Coursier cache context has been set up: $COURSIER_CACHE."
