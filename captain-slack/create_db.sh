#!/bin/bash
# shellcheck disable=SC2034,SC2129,SC2027,SC2086
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
            #echo "$key = $value"  # Automatically echo the key-value pair for testing not need in real.. 
        fi
    done < "$CONFIG_FILE"
}

# Call the function to source the config
source_config

mkdir -p /var/log/captain-slack || exit 9
DATE="$(date)"
# Setup build log file
LOGFILE=/var/log/captain-slack/cptn-main.log
# shellcheck disable=SC2086
rm $LOGFILE || true
touch "$LOGFILE"
exec > >(tee -a "$LOGFILE") 2>&1

# Function to process the package line
process_package_line() {
    local line="$1"

    # Use regex to extract the parts
    if [[ $line =~ Package:\ ([^,]+),\ Version:\ ([^,]+),\ Architecture:\ ([^,]+),\ Build\ Version:\ ([^,]+)(,\ Tag:\ ([^,]+))? ]]; then
        local package_name="${BASH_REMATCH[1]}"
        local version="${BASH_REMATCH[2]}"
        local architecture="${BASH_REMATCH[3]}"
        local build_version="${BASH_REMATCH[4]}"
        local tag="${BASH_REMATCH[6]}"

        # Generate YAML entry
        echo "- package: ${package_name}" >> "$PKG_DB"/packages.yaml
        echo "  version: ${version}" >> "$PKG_DB"/packages.yaml
        echo "  build_version: ${build_version}" >> "$PKG_DB"/packages.yaml  # Added build_version here
        if [ -n "$tag" ]; then
            echo "  tag: ${tag}" >> "$PKG_DB"/packages.yaml
        fi
    else
        echo "Invalid package format: $line" >> "$LOGFILE"
    fi
}

# Main script execution
input_file="$PKG_DB/installed_packages.txt"  # Change this to your actual file path

# Check if the input file exists
if [[ ! -f "$input_file" ]]; then
    echo "Input file not found!"
    exit 1
fi

# Create or clear the output YAML file
touch "$PKG_DB"/packages.yaml
echo "" > "$PKG_DB"/packages.yaml

# Read the file and process each line
while IFS= read -r line; do
    process_package_line "$line"
done < "$input_file"

echo "File created: "$PKG_DB"/packages.yaml"
