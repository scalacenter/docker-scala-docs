#!/usr/bin/env bash
set -eu

export IVY_CACHE="$HOME/.ivy2"
mkdir -p "$DRONE_DIR/.ivy2"
test -d "$IVY_CACHE" || \
  test -h "$IVY_CACHE" || \
  (ln -s "$DRONE_DIR/.ivy2" "$IVY_CACHE" && \
  echo "Ivy cache has been set up: $IVY_CACHE.")

export COURSIER_CACHE="$HOME/.coursier"
mkdir "$DRONE_DIR/.coursier"
test -d "$COURSIER_CACHE" || \
  test -h "$COURSIER_CACHE" || \
  mkdir "$DRONE_DIR/.coursier" || \
  (ln -s "$DRONE_DIR/.coursier" "$COURSIER_CACHE"  && \
  echo "Coursier cache context has been set up: $COURSIER_CACHE.")
