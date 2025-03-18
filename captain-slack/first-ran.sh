#!/bin/bash
# shellcheck disable=SC2034

# I add this script because in some systems make-db -a dont work first time...
# so now user will ran this script first time installation to be sure that the second time when make-db run cptn-main.ini will be sourced.


# Try to source the configuration file ini and see if it works
CONFIG_FILE=/etc/captain-slack/cptn-main.ini

# Parse the config file and export variables ;)
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
        fi
    done < "$CONFIG_FILE"
}

# Call the function to source the config
source_config

mkdir -p /var/log/captain-slack || exit 9
DATE="$(date)"
# Setup build log file
LOGFILE=/var/log/captain-slack/debug_output.log
# shellcheck disable=SC2086
rm $LOGFILE || true
exec > >(tee -a "$LOGFILE") 2>&1

# Echo all variables sourced from the config file
echo "Variables sourced from $CONFIG_FILE:"
while IFS="=" read -r key value; do
    if [[ $key =~ ^\[(.*)\]$ ]]; then
        echo "Section: ${BASH_REMATCH[1]}"
    elif [[ -n $key && -n $value && $key != ";"* ]]; then
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        echo "$key=$value"
    fi
done < "$CONFIG_FILE"

# Optionally, list all exported variables related to this script
echo "Exported environment variables:"
env | grep -E "$(basename "$CONFIG_FILE" | sed 's/\./\\./g')"
