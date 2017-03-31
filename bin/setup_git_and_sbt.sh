#!/usr/bin/env bash
set -eux

git config --global user.email "ci@platform.scala-lang.org"
git config --global user.name "The Scala Platform CI Bot"
echo "Git meta data has been configured."
