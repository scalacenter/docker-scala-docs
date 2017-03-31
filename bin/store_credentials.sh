#!/usr/bin/env bash
set -eux

BINTRAY_FOLDER="$HOME/.bintray"
CREDENTIALS_FILE="$BINTRAY_FOLDER/.credentials"

create_bintray_file() {
  mkdir "$BINTRAY_FOLDER"
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
