#!/bin/bash
# shellcheck disable=SC2034,SC2046,SC2006,SC2086
# this is a fork of rccheck with thanks to the original developer.
# http://distro.ibiblio.org/amigolinux/download/AmigoProjects/Sys-Utils/
# Execute this script as either sudo or root.
#
# Updated from rizitis to support $1
FILTER="${1:-}"

files="$( grep "start" $(find /etc/rc.d/rc* -executable -type f ! -regex '.*rc.[0-6A-S].*') | awk -F'[:.]' '{ print $3 }' | uniq )"
IFS=$'\n' read -r -d '' -a files_array <<< "$files"

if [[ -n "$FILTER" ]]; then
    filtered=()
    for s in "${files_array[@]}"; do
        [[ "$s" == *"$FILTER"* ]] && filtered+=("$s")
    done
    files_array=("${filtered[@]}")
fi

echo -e "$(tput setaf 14) Running Services $(tput sgr0)"

if [[ -n "$FILTER" && ${#files_array[@]} -eq 0 ]]; then
    echo -e "$(tput setaf 9) Service '$FILTER' not found in running services. $(tput sgr0)"
else
    for EACH in "${files_array[@]}"; do
      EVENED=`echo "$EACH        " | cut -c -14`
      netstat -a | grep -ic -m 1 $EACH >/dev/null ||\
      ps ax | grep -v echo | grep -v grep | grep -ic -m 1 $EACH >/dev/null && \
      echo -e "		$EVENED	$(tput setaf 10)[   OK   ] $(tput sgr0)" || \
      echo "		$EVENED	$(tput setaf 9)[   OK   ] $(tput sgr0)"
    done
fi

status="$( grep "|status" $(find /etc/rc.d/rc* -executable -type f) | awk -F'[:.]' '{ print $3 }' | uniq )"
IFS=$'\n' read -r -d '' -a status_array <<< "$status"

if [[ -n "$FILTER" ]]; then
    filtered=()
    for s in "${status_array[@]}"; do
        [[ "$s" == *"$FILTER"* ]] && filtered+=("$s")
    done
    status_array=("${filtered[@]}")
fi

echo ""
echo ""
echo -e "$(tput setaf 14) Available status of Services $(tput sgr0)"
[[ -z "$FILTER" ]] && sleep 3

if [[ -n "$FILTER" && ${#status_array[@]} -eq 0 ]]; then
    echo -e "$(tput setaf 9) Service '$FILTER' has no status command available. $(tput sgr0)"
else
    for EACH in "${status_array[@]}"; do
      echo ""
      echo -e "$(tput setaf 14) Status $EACH  $(tput sgr0)"
      /etc/rc.d/rc.$EACH status
    done
fi
