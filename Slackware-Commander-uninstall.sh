#!/bin/bash

dir1=/usr/share/icons/Slackware-Commander/
dir2=/usr/share/applications/
dir3=/usr/local/bin/

rm -r "$dir1" || exit 
rm "$dir2"/Slackware-Commander.desktop 
rm "$dir3"/Slackware-Commander.sh 
rm "$dir3"/SLCMD2.sh
rm "$dir3"/SBKS
rm "$dir3"/whoRyou
rm "$dir3"/rcstatus
rm "$dir3"/Slackware-Commander-uninstall.sh
updatedb


