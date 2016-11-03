#!/usr/bin/env bash

KEYS_DIR="/keys"
GPG_DIR="$DRONE_DIR/.gnupg"
SSH_DIR="$DRONE_DIR/.ssh"
GPG_KEYS=("$KEYS_DIR/platform.pubring.asc" "$KEYS_DIR/platform.secring.asc")
SSH_KEYS=("$KEYS_DIR/id_rsa" "$KEYS_DIR/id_rsa.pub")

test -d ${GPG_DIR} || mkdir ${GPG_DIR}
test -d ${SSH_DIR} || mkdir ${SSH_DIR}

for GPG_KEY in ${GPG_KEYS[@]}; do
  if [[ ! -e $GPG_KEY ]]; then
    mv ${GPG_KEY} ${GPG_DIR}
  fi
done

for SSH_KEY in ${SSH_KEYS[@]}; do
  if [[ ! -e $GPG_KEY ]]; then
    mv ${SSH_KEY} ${SSH_DIR}
  fi
done
echo "Keys have been moved."
