#!/bin/bash

dep_name="google-go-lang"
GO_VERSION="1.26.3"

_log "Downloading ${dep_name} from SBo..."
curl -L "https://slackbuilds.org/slackbuilds/15.0/development/${dep_name}.tar.gz" \
    -o "${dep_name}.tar.gz" || _err "Failed to download ${dep_name}"

tar xf "${dep_name}.tar.gz"
pushd "${dep_name}" || exit 1

unset PKG OUTPUT

_log "Downloading Go source tarballs..."
for ver in 1.19.13 1.21.13 1.23.12 1.25.10 1.26.3; do
    wget "https://go.dev/dl/go${ver}.src.tar.gz" || _err "Failed to download go${ver}.src.tar.gz"
done

chmod +x "${dep_name}.SlackBuild"
VERSION="$GO_VERSION" bash "${dep_name}.SlackBuild" || _err "${dep_name} build failed"

upgradepkg --install-new --reinstall /tmp/$dep_name-$GO_VERSION-*.t?z

popd || exit 1
