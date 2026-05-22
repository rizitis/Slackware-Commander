#!/bin/bash

dep_name="google-go-lang"
GO_VERSION="1.26.3"

_log "Downloading ${dep_name} from SBo..."
curl -L "https://slackbuilds.org/slackbuilds/15.0/development/${dep_name}.tar.gz" \
    -o "${dep_name}.tar.gz" || _err "Failed to download ${dep_name}"

tar xf "${dep_name}.tar.gz"
pushd "${dep_name}" || exit 1

unset PKG OUTPUT
source "${dep_name}.info"

_log "Downloading Go ${GO_VERSION} source..."
wget "https://go.dev/dl/go1.26.3.src.tar.gz" || _err "Failed to download Go source"

chmod +x "${dep_name}.SlackBuild"
VERSION="1.26.3" bash "${dep_name}.SlackBuild" || _err "${dep_name} build failed"

upgradepkg --install-new --reinstall /tmp/$PRGNAM-*.t?z

popd || exit 1
