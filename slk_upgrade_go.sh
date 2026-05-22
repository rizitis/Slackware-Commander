#!/bin/bash

sbo_txt_url="https://slackbuilds.org/slackbuilds/15.0/SLACKBUILDS.TXT"
sbo_txt_cache="/tmp/SLACKBUILDS.TXT"

if [[ ! -f "$sbo_txt_cache" ]]; then
    _log "Fetching SLACKBUILDS.TXT..."
    curl -sL "$sbo_txt_url" -o "$sbo_txt_cache"
fi

dep_name="google-go-lang"

_log "Downloading ${dep_name} from SBo..."
wget "https://go.dev/dl/go${VERSION}.src.tar.gz" || _err "Failed to download source for ${dep_name}"

tar xf "${dep_name}.tar.gz"
pushd "${dep_name}" || exit 1

unset PKG OUTPUT
source "${dep_name}.info"

_log "Downloading source for ${dep_name}..."
curl -L "$DOWNLOAD" -o "$(basename "$DOWNLOAD")" || _err "Failed to download source for ${dep_name}"

chmod +x "${dep_name}.SlackBuild"
bash "${dep_name}.SlackBuild" || _err "${dep_name} build failed"

upgradepkg --install-new --reinstall /tmp/$PRGNAM-$VERSION-*.t?z

export PATH="/usr/lib64/go/bin:$PATH"
_log "Go upgraded to: $(go version)"

popd || exit 1
