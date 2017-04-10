#!/usr/bin/env bash

set +u

if [[ -z "$DRONE_PULL_REQUEST" ]]; then
  BINTRAY_USERNAME="CI_MOCKUP_PULL_REQUEST"
  BINTRAY_PASSWORD="fake password"
fi

set -eu

BINTRAY_FOLDER="$HOME/.bintray"
CREDENTIALS_FILE="$BINTRAY_FOLDER/.credentials"

create_bintray_file() {
  mkdir -p "$BINTRAY_FOLDER"
cat <<EOF >> "$CREDENTIALS_FILE"
realm = Bintray API Realm
host = api.bintray.com
user = $BINTRAY_USERNAME
password = $BINTRAY_PASSWORD
EOF
  echo "Created $CREDENTIALS_FILE."
}

([[ -e "CREDENTIALS_FILE" ]] && echo "Skipped creation of bintray credentials. $CREDENTIALS_FILE exists.") \
  || create_bintray_file
