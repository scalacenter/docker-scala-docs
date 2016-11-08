#!/usr/bin/env bash

KEYS_DIR="/keys"
GPG_DIR="$DRONE_DIR/.gnupg"
SSH_DIR="$DRONE_DIR/.ssh"
GPG_KEYS=("$KEYS_DIR/platform.pubring.asc" "$KEYS_DIR/platform.secring.asc")
SSH_KEYS=("$KEYS_DIR/id_rsa" "$KEYS_DIR/id_rsa.pub")

test -d ${GPG_DIR} || mkdir ${GPG_DIR}
test -d ${SSH_DIR} || mkdir ${SSH_DIR}

if [[ -d $KEYS_DIR ]]; then
  for GPG_KEY in ${GPG_KEYS[@]}; do
    GPG_FILENAME=$(basename $GPG_KEY)
    if [[ ! -e "$GPG_DIR/$GPG_FILENAME" ]]; then
      echo "Copying $GPG_KEY to $GPG_DIR."
      cp $GPG_KEY $GPG_DIR
    fi
  done

  for SSH_KEY in ${SSH_KEYS[@]}; do
    SSH_FILENAME=$(basename $SSH_KEY)
    if [[ ! -e "$SSH_DIR/$SSH_FILENAME" ]]; then
      echo "Copying $SSH_KEY to $SSH_DIR."
      cp $SSH_KEY $SSH_DIR
    fi
  done

  echo "Keys have been moved."
fi
