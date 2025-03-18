#!/bin/bash

# shellcheck disable=SC2188,SC2086,SC2129,SC2162

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
            #echo "$key = $value"  # Automatically echo the key-value pair for testing not need in real..
        fi
    done < "$CONFIG_FILE"
}

# Call the function to source the config
source_config

# Ensure that we received an argument
if [ -z "$1" ]; then
  echo "Usage: cmd <name>"
  exit 1
fi

# Output file
yaml_file="$PKG_DB"/"app_dependencies.yaml"
# Store the argument in a variable
package_name="$1"

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print package name with color (optional)
echo -e "${BLUE}Searching for package: $package_name${NC}"

# Use awk with variable expansion and color output
awk -v pkg="$package_name" -v RED="$RED" -v GREEN="$GREEN" -v NC="$NC" '
/- name: / {flag=($3 == "\"" pkg "\"")}
flag {
    if (/name: /) {
        print GREEN $0 NC
    } else {
        print RED $0 NC
    }
}' "$yaml_file"



# Define the YAML file to parse
#yaml_file22="app_dependencies.yaml"  # Replace with your actual YAML file path

#package_name="$1"

#awk -v pkg="$package_name" '/- name: / {flag=($3 == "\"" pkg "\"")} flag' "$yaml_file22"

