#!/bin/bash

sbo_txt="/tmp/SLACKBUILDS.TXT"

SBSCRIPT="$(find "${BUILDDIR}" -maxdepth 1 -name '*.SlackBuild' | head -1)"
JUST_NAME=$(basename "$SBSCRIPT" .SlackBuild)
DEPS_FILE="$JUST_NAME".dep

slk_sbo_check_version() {
    local dep_name="$1"
    local SBo_NAME="$dep_name"-"$VERSION"
    local SBo_EXPECTED="$PRGNAM-$VERSION"
    local SBo_INSTALLED
    SBo_INSTALLED="$(ls /var/log/packages/${SBo_NAME}-* 2>/dev/null \
                  | sed "s|.*/${SBo_NAME}-||;s|-[^-]*-[^-]*\$||" \
                  | tail -1)"
    if [[ "${SBo_INSTALLED}" == "${SBo_EXPECTED}" ]]; then
        _log "Version check passed: ${dep_name} ${SBo_INSTALLED}"
    else
        _err "Version mismatch: expected $PRGNAM-$VERSION, found '${SBo_INSTALLED}'"
    fi
}

if [ ! -f "$DEPS_FILE" ]; then
    _log "no deps found for $JUST_NAME"
else
    while IFS= read -r dep_name; do
        [ -z "$dep_name" ] && continue
        _log "Looking up '${dep_name}' in SBo..."
        location=$(grep -A5 "^SLACKBUILD NAME: ${dep_name}$" "$sbo_txt" \
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
        chmod +x "${dep_name}.SlackBuild"
        bash "${dep_name}.SlackBuild"
        _log "${dep_name} Build succeeded."

        _log "Installing ${dep_name}..."
        installpkg --terse /tmp/$PRGNAM-$VERSION-*.t?z

        slk_sbo_check_version "$dep_name"

        rm /tmp/$PRGNAM-$VERSION-*.t?z

        info_vars=$(grep -v '^#' "${dep_name}.info" | cut -d= -f1)
        popd || exit 1
        unset $info_vars

        _log "All Done: ${dep_name}"
    done < "$DEPS_FILE"
fi
