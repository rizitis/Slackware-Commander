#!/bin/bash

source slk-ci.sh
SBSCRIPT="$(find "${BUILDDIR}" -maxdepth 1 -name '*.SlackBuild' | head -1)"
JUST_NAME=$(basename "$SBSCRIPT" .SlackBuild)

DEPS_FILE="$JUST_NAME".dep

sbo_txt_url="https://slackbuilds.org/slackbuilds/15.0/SLACKBUILDS.TXT"
sbo_txt_cache="/tmp/SLACKBUILDS.TXT"
declare -A visited
deplist=()


fetch_sbo_txt() {
  if [[ ! -f "$sbo_txt_cache" ]]; then
    _log "Fetching SLACKBUILDS.TXT..."
    curl -sL "$sbo_txt_url" -o "$sbo_txt_cache"
  fi
}

get_location() {
  local name="$JUST_NAME"
  grep -A5 "^SLACKBUILD NAME: $JUST_NAME$" "$sbo_txt_cache" \
    | grep "^SLACKBUILD LOCATION:" | head -1 \
    | awk '{print $3}' | sed 's|^\./||'
}

get_requires() {
  local name="$JUST_NAME"
  grep -A10 "^SLACKBUILD NAME: $JUST_NAME$" "$sbo_txt_cache" \
    | grep "^SLACKBUILD REQUIRES:" | head -1 \
    | sed 's/^SLACKBUILD REQUIRES://' | xargs
}

resolve_deps() {
  local name="$JUST_NAME"

  [[ "${visited[$JUST_NAME]+_}" ]] && return
  visited[$JUST_NAME]=1

  local location
  location=$(get_location "$JUST_NAME")
  [[ -z "$location" ]] && return

  local requires
  requires=$(get_requires "$JUST_NAME")
  [[ -z "$requires" ]] && return

  for dep in $requires; do
    [[ "$dep" == "%README%" ]] && continue
    resolve_deps "$dep"
    deplist+=("$dep")
  done
}

# --- main ---

if [[ -z "$JUST_NAME" ]]; then
  _err "Ops $0 was not set properly JUST_NAME"
  exit 1
fi

if [ -f "$DEPS_FILE" ]; then
    _log "deps file found for $JUST_NAME"
else
fetch_sbo_txt

_log "Resolving dependencies for $JUST_NAME..."

resolve_deps "$JUST_NAME"

# deduplicate deps in order.
seen=()
declare -A seen_map
for dep in "${deplist[@]}"; do
  if [[ ! "${seen_map[$dep]+_}" ]]; then
    seen_map[$dep]=1
    seen+=("$dep")
  fi
done

if [[ ${#seen[@]} -eq 0 ]]; then
  _log "No dependencies found."
else
  printf '%s\n' "${seen[@]}" > "$JUST_NAME.dep"
  _log "Done: $JUST_NAME.dep (${#seen[@]} packages)"
fi
fi
