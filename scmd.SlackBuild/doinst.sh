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

mandb

update_config() {
    config_file="$1"
    new_config_file="$2"

    if [ ! -f "$config_file" ]; then
        mv "$new_config_file" "$config_file"
    fi

    if diff -u "$config_file" "$new_config_file" > /dev/null; then
        rm "$new_config_file"
    else
        cp "$config_file" "${config_file}.orig"
        echo "Attention: ${new_config_file} detected..."
    fi
}

update_config "etc/inxifetch/inxifetch.conf" "etc/inxifetch/inxifetch.conf.new"
update_config "etc/captain-slack/cptn-main.ini" "etc/captain-slack/cptn-main.ini.new"


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
