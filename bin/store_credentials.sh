#!/usr/bin/env bash

BINTRAY_FOLDER="$HOME/.bintray"
CREDENTIALS_FILE="$BINTRAY_FOLDER/.credentials"

test -d $BINTRAY_FOLDER || mkdir $BINTRAY_FOLDER
cat <<EOF >> $CREDENTIALS_FILE
realm = Bintray API Realm
host = api.bintray.com
user = $BINTRAY_USERNAME
password = $BINTRAY_PASSWORD
EOF
echo "Created $CREDENTIALS_FILE."
