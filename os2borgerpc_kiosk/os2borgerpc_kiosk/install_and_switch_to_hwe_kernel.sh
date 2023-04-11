#! /usr/bin/env sh

export DEBIAN_FRONTEND=noninteractive

ACTIVATE=$1

if ! get_os2borgerpc_config os2_product | grep --quiet kiosk; then
  echo "Dette script er ikke designet til at blive anvendt på en regulær OS2borgerPC-maskine."
  exit 1
fi

VERSION_NUMBER=$(lsb_release -d | cut --delimiter " " --fields 2 | cut --delimiter "." --fields "1 2")

PKG="linux-generic-hwe-$VERSION_NUMBER"

if [ "$ACTIVATE" = 'True' ]; then
  apt-get install --assume-yes "$PKG"
else
  apt-get remove --assume-yes "$PKG"
fi
