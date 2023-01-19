#! /usr/bin/env sh

ACTIVATE=$1
FILE=$2

if [ "$ACTIVATE" = 'True' ]; then
  echo "##### Attempting to install Microsoft Teams #####"
  apt-get update --assume-yes
  apt-get install --fix-broken "$FILE" --assume-yes
else
  echo "##### Removing Microsoft Teams #####"
  apt-get purge teams --assume-yes
fi

rm "$FILE"
apt autoremove --assume-yes
