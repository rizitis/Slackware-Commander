#!/bin/bash

# Color Definitions
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"  # Reset to default color

# shellcheck disable=SC2034
# This script interacts with https://mirrors.slackware.com/mirrorlist/ and downloads the updated mirrorlist.
# Then splits the file into 3 parts: http, ftp, rsync in $MIR_DIR (/var/lib/captain-slack/mirror-test/)
# Edit files to make them pretty and ready to be used if arch != aarch64
# If arch = aarch64, then only ping the existing mirrorlist (/var/lib/captain-slack/mirror-test/aarch64-mirrors.txt)
# and print the fastest server for your location.

# shellcheck disable=SC1091
. /etc/os-release

CONFIG_FILE="/etc/captain-slack/cptn-main.ini"

# Parse the ini file and export variables
function source_config() {
    local section=""
    while IFS="=" read -r key value; do
        if [[ $key =~ ^\[(.*)\]$ ]]; then
            section="${BASH_REMATCH[1]}"
        elif [[ -n $key && -n $value && $key != ";"* && $section != "" ]]; then
            key=$(echo "$key" | xargs)  # Trim whitespace
            value=$(echo "$value" | xargs)  # Trim whitespace
            value=$(eval echo "$value")  # Resolve variables like $APP_HOME
            export "$key"="$value"  # Export as environment variable
            #echo "$key = $value"  # Automatically echo the key-value pair
        fi
    done < "$CONFIG_FILE"
}

# Call the function to source the config
source_config

mkdir -p /var/log/captain-slack || exit 9
DATE="$(date)"
# Setup build log file
LOGFILE=/var/log/captain-slack/mirrors.log
# shellcheck disable=SC2086
rm $LOGFILE || true
exec > >(tee -a "$LOGFILE") 2>&1

cd "$MIR_DIR" || exit 1

if [ "$ARCH" != "aarch64" ]; then
    # URL to fetch mirrors from
    URL="https://mirrors.slackware.com/mirrorlist/"
    # Temp file to store the fetched page
    temp_file=$(mktemp)

    # Fetch the page source
    # shellcheck disable=SC2086
    curl -s "$URL" > $temp_file

    # Extract and save HTTP mirrors to http.mirrors.txt
    grep -oP 'https?://[^"]+' "$temp_file" | sed 's/>.*$//' > http.mirrors.txt

    # Extract and save FTP mirrors to ftp.mirrors.txt
    grep -oP 'ftp://[^"]+' "$temp_file" | sed 's/>.*$//' > ftp.mirrors.txt

    # Extract and save rsync mirrors to rsync.mirrors.txt
    grep -oP 'rsync://[^"]+' "$temp_file" | sed 's/>.*$//' > rsync.mirrors.txt

    # Clean up temporary file
    rm "$temp_file"

    # lets make it ready for script to be sourced as is...
    sed -i 's/^/"&/; s/$/"/' http.mirrors.txt
    sed -i 's/^/"&/; s/$/"/' ftp.mirrors.txt
    sed -i 's/^/"&/; s/$/"/' rsync.mirrors.txt

    for file in http.mirrors.txt ftp.mirrors.txt rsync.mirrors.txt; do
        sed -i '1s/^/mirrors=(\n/' "$file"
    done

    for file in http.mirrors.txt ftp.mirrors.txt rsync.mirrors.txt; do
        echo ")" >> "$file"
    done

    echo -e "${GREEN}Mirrors have been saved to $MIR_DIR/{http.mirrors.txt,ftp.mirrors.txt,rsync.mirrors.txt}${RESET}"

else
    echo -e "${YELLOW}$ARCH${RESET}"
fi

declare -A mirror_times

if [ "$ARCH" != "aarch64" ]; then
    # List of rsync mirrors
    # shellcheck disable=SC1091
    . "$MIR_DIR"/http.mirrors.txt
else
    [ "$ARCH" = "aarch64" ]
    . "$MIR_DIR"/aarch64-mirrors.txt
fi

# Loop through mirrors and ping each one
# shellcheck disable=SC2154
for mirror in "${mirrors[@]}"; do
    # Skip mirrors from w3.org
    if [[ "$mirror" == *"w3.org"* ]]; then
        continue
    fi

    # Extract the hostname (remove protocol and path)
    hostname=$(echo "$mirror" | awk -F'/' '{print $3}')

    # Ping the mirror hostname and get the average response time
    ping_time=$(ping -c 1 -W 1 "$hostname" | grep 'time=' | awk -F 'time=' '{print $2}' | awk '{print $1}')

    # If the ping was successful and we got a valid time
    if [[ -n "$ping_time" ]]; then
        echo -e "${GREEN}Pinged $hostname: $ping_time ms${RESET}"
        # Store the mirror and its ping time in the associative array
        mirror_times["$mirror"]="$ping_time"
    else
        echo -e "${RED}Failed to ping $hostname${RESET}"
    fi
done


# Check if any mirrors responded
if [ ${#mirror_times[@]} -eq 0 ]; then
    echo -e "${RED}No mirrors responded.${RESET}"
    exit 1
fi
echo ""

number_flag="$1"
# Sort the mirrors by their ping times and print the top 3

if [ ! "$number_flag" ]; then
    echo -e "${GREEN}Top 5 fastest mirrors for your location:${RESET}"
    for mirror in "${!mirror_times[@]}" ; do
        echo "$mirror ${mirror_times[$mirror]}"
    done | sort -k2 -n | head -n 5
else
    number_flag_var="${number_flag#-}"
    echo -e "${GREEN}Top $number_flag_var fastest mirrors for your location:${RESET}"
    for mirror in "${!mirror_times[@]}" ; do
        echo "$mirror ${mirror_times[$mirror]}"
    done | sort -k2 -n | head -n "$number_flag_var"
fi

echo ""
