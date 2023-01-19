#! /bin/bash

set -x

ACTIVATE=$1

URL="https://download.teamviewer.com/download/teamviewer_qs.tar.gz"
ARCHIVE=$(basename "$URL")
INSTALL_TEMP_PATH="/home/user/.local/opt"
INSTALL_PATH="/home/.skjult/.local/opt"

if [ "$ACTIVATE" = 'True' ]; then

    # Download teamviewer quick support (distributed as an archive).
    curl -L -O $URL

    tar -xf "$ARCHIVE" && rm "$ARCHIVE"

    mkdir --parents $INSTALL_TEMP_PATH $INSTALL_PATH

    mv teamviewerqs $INSTALL_TEMP_PATH/teamviewerqs

    chown -R user:user $INSTALL_TEMP_PATH/teamviewerqs
    runuser -l user -c $INSTALL_TEMP_PATH/teamviewerqs/teamviewer

    cp -r $INSTALL_TEMP_PATH/teamviewerqs $INSTALL_PATH/
    chown -R root:root $INSTALL_PATH/teamviewerqs

    cp $INSTALL_PATH/teamviewerqs/teamviewer.desktop /usr/share/applications/

else

    rm -Rf $INSTALL_TEMP_PATH/teamviewerqs $INSTALL_PATH/teamviewerqs
    rm /usr/share/applications/teamviewer.desktop

fi
