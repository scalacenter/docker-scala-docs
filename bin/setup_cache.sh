#!/usr/bin/env bash
set -eu

export IVY_CACHE="$HOME/.ivy2"
mkdir -p "$DRONE_DIR/.ivy2"
test -d "$IVY_CACHE" || \
  test -h "$IVY_CACHE" || \
  (ln -s "$DRONE_DIR/.ivy2" "$IVY_CACHE" && \
  echo "Ivy cache has been set up: $IVY_CACHE.")

export COURSIER_CACHE="$HOME/.coursier"
mkdir -p "$DRONE_DIR/.coursier"
test -d "$COURSIER_CACHE" || \
  test -h "$COURSIER_CACHE" || \
  (ln -s "$DRONE_DIR/.coursier" "$COURSIER_CACHE"  && \
  echo "Coursier cache context has been set up: $COURSIER_CACHE.")

export SBT_HOME_DIR="$HOME/.sbt"
mkdir -p "$DRONE_DIR/.sbt"
test -d "$SBT_HOME_DIR" || \
  test -h "$SBT_HOME_DIR" || \
  (ln -s "$DRONE_DIR/.sbt" "$SBT_HOME_DIR"  && \
  echo "Sbt cache context has been set up: $SBT_HOME_DIR.")
