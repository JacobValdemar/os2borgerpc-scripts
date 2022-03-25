#!/bin/bash

file=$1

if dpkg -l "cisco-jvdi-client" > /dev/null
then
    echo "#############################################################"
    echo "# Removing already installed Cisco Jabber and configuration #"
    echo "#############################################################"
    apt-get purge cisco-jvdi-client -y
fi

echo "############################"
echo "# Installing Cisco Jabber. #"
echo "############################"
apt-get update -y
apt-get install -f "$file" -y
rm "$file"
sudo apt autoremove -y