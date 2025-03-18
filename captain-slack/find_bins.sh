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

# Output file
output_file="$PKG_DB"/"app_dependencies.yaml"
mkdir -p "$PKG_DB" || exit 99
# Create or clear the output file
> "$output_file"

# Define the PATH directories to check (avoiding duplicates)
PATH_DIRECTORIES=$(echo $PATH | tr ':' '\n' | awk '!x[$0]++')

# Write the header to the YAML file
echo "applications:" > "$output_file"

# Locate all executables in the directories listed in $PATH
echo "Locating executables in directories from PATH..."

# Loop through each directory in $PATH and find executable files
for dir in $PATH_DIRECTORIES; do
    echo "Searching in directory: $dir"
    find "$dir" -maxdepth 1 -type f -executable | while read executable; do
        echo "Checking dependencies for $executable"

        # Add executable to YAML file
        echo "  - name: \"$(basename "$executable")\"" >> "$output_file"
        echo "    path: \"$executable\"" >> "$output_file"
        echo "    dependencies:" >> "$output_file"

        # Get the dependencies using ldd and format them into the YAML
        ldd "$executable" | while read line; do
            # Extract the library and path
            lib_name=$(echo $line | cut -d' ' -f1)
            lib_path=$(echo $line | awk '{print $3}')

            # Only process lines with "=>" (valid dependency lines)
            if [[ "$lib_path" != "" && "$lib_path" != "(0x*" ]]; then
                echo "      - \"$lib_name\" => \"$lib_path\"" >> "$output_file"
            fi
        done
    done
done

echo "Dependency check complete! Output saved to $output_file"
