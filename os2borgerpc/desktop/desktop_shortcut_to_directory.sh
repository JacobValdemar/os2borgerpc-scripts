#! /usr/bin/env sh

# Places a shortcut on the Desktop to any directory on the file system
#
# Parameters:
#   1: Whether to add or remove the shortcut
#   2: The path to the directory you want a shortcut to
#   3: The name of the shortcut on the Desktop

set -ex

ADD="$1"
DIRECTORY="$2"
SHORTCUT_NAME="$3"

SHADOW_DESKTOP="/home/.skjult/Skrivebord"

mkdir --parents $SHADOW_DESKTOP

if [ "$ADD" = "True" ]; then
  # Note: "ln" doesn't care if the destination ($DIRECTORY) exists
  ln --symbolic --force "$DIRECTORY" "$SHADOW_DESKTOP/$SHORTCUT_NAME"
else
  rm "$SHADOW_DESKTOP/$SHORTCUT_NAME"
fi
