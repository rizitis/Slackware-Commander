config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`md5sum $OLD | cut -d' ' -f1`" = "`md5sum $NEW | cut -d' ' -f1`" ]; then
    mv $NEW $OLD
  fi
}

config etc/captain-slack/cptn-main.ini.new
config etc/inxifetch/inxifetch.conf.new

MAN_DIR=/usr/man/man1

if [ -d "$MAN_DIR" ]; then
  cd "$MAN_DIR" || exit 1

  if [ -e slackware-commander.1.gz ] || [ -L slackware-commander.1.gz ]; then
    rm -f slackware-commander.1.gz
  fi

  if [ -e scmd.1.gz ]; then
    ln -s scmd.1.gz slackware-commander.1.gz
  fi
fi

if [ -x /usr/bin/update-desktop-database ]; then
  /usr/bin/update-desktop-database -q usr/share/applications >/dev/null 2>&1
fi

if [ -x /usr/bin/update-mime-database ]; then
  /usr/bin/update-mime-database usr/share/mime >/dev/null 2>&1
fi


if [ -e usr/share/icons/hicolor/icon-theme.cache ]; then
  if [ -x /usr/bin/gtk-update-icon-cache ]; then
    /usr/bin/gtk-update-icon-cache -f usr/share/icons/hicolor >/dev/null 2>&1
  fi
fi
