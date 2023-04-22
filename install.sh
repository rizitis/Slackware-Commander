#!/bin/bash

dir1=/usr/share/icons/Slackware-Commander/
dir2=/usr/share/applications/
dir3=/usr/local/bin/

mkdir -p "$dir1" || exit 
cp Slackware-Commander.png "$dir1"
cp slackware_logo_med.png "$dir1"
cp slackware_whitelogo_med.png "$dir1"
cp slackware.png "$dir1"
cp Slackware-Commander.desktop "$dir2"
cp Slackware-Commander.sh "$dir3"
chmod +x "$dir3"/Slackware-Commander.sh
cp rcstatus "$dir3"
chmod +x "$dir3"/rcstatus
cp Slackware-Commander-uninstall.sh "$dir3"
chmod +x "$dir3"/Slackware-Commander-uninstall.sh
updatedb

