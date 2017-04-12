#!/usr/bin/env bash

set +u

if [[ -z "$BINTRAY_USERNAME" && -z "$BINTRAY_PASSWORD" ]]; then
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

else
  echo "Skipped creation of bintray credentials file. Missing \$BINTRAY_USERNAME and \$BINTRAY_PASSWORD."
fi

