#!/bin/bash

export PATH="/usr/lib64/go1.26.3/go/bin:$PATH"
export PYTHONPATH="/usr/lib64/python3.$(python3 -c 'import sys; print(sys.version_info.minor)')/site-packages:$PYTHONPATH"

sbo_txt_url="https://slackbuilds.org/slackbuilds/15.0/SLACKBUILDS.TXT"
sbo_txt_cache="/tmp/SLACKBUILDS.TXT"

SBSCRIPT="$(find "${BUILDDIR}" -maxdepth 1 -name '*.SlackBuild' | head -1)"
JUST_NAME=$(basename "$SBSCRIPT" .SlackBuild)
DEPS_FILE="$JUST_NAME".dep

fetch_sbo_txt() {
  if [[ ! -f "$sbo_txt_cache" ]]; then
    _log "Fetching SLACKBUILDS.TXT..."
    curl -sL "$sbo_txt_url" -o "$sbo_txt_cache"
  fi
}

if [ ! -f "$DEPS_FILE" ]; then
    _log "no deps found for $JUST_NAME"
else
    fetch_sbo_txt
    while IFS= read -r dep_name; do
        [ -z "$dep_name" ] && continue
        _log "Looking up '${dep_name}' in SBo..."
        location=$(grep -A5 "^SLACKBUILD NAME: ${dep_name}$" "$sbo_txt_cache" \
            | grep "^SLACKBUILD LOCATION:" | head -1 \
            | awk '{print $3}' | sed 's|^\./||')

        if [[ -z "$location" ]]; then
            _err "'${dep_name}' not found in SLACKBUILDS.TXT"
            _slk_detect_version
            if [[ "$SLK_VERSION" == "current" ]]; then
                _log "Maybe '${dep_name}' already in current?"
                _log "In this case should be mentioned on build_deps: in .yml file"
                exit 1
            fi
        fi

        _log "Found: ${location}"

        tmp=$(mktemp -d)
        git clone --depth=1 --filter=blob:none --sparse \
            https://github.com/Ponce/slackbuilds.git -b current "$tmp/repo" -q
        cd "$tmp/repo"
        git sparse-checkout set "$location"
        tar czf "${OLDPWD}/${dep_name}.tar.gz" -C "$tmp/repo/$location/.." "$dep_name"
        cd "$OLDPWD"
        rm -rf "$tmp"

        tar xf "${dep_name}.tar.gz"
        pushd "${dep_name}" || exit 1

        unset PKG OUTPUT
        source "${dep_name}.info"

        _log "Downloading source for ${dep_name}..."
        curl -L "$DOWNLOAD" -o "$(basename "$DOWNLOAD")" || _err "Failed to download source for ${dep_name}"

        chmod +x "${dep_name}.SlackBuild"
        bash "${dep_name}.SlackBuild" || _err "${dep_name} build failed"
        _log "${dep_name} Build succeeded."

        _log "Installing ${dep_name}..."
#        installpkg --terse /tmp/$PRGNAM-$VERSION-*.t?z
        upgradepkg --install-new --reinstall /tmp/$PRGNAM-$VERSION-*.t?z

        rm /tmp/$PRGNAM-$VERSION-*.t?z

        info_vars=$(grep -v '^#' "${dep_name}.info" | cut -d= -f1)
        popd || exit 1
        unset $info_vars

        _log "All Done: ${dep_name}"
    done < "$DEPS_FILE"
fi
