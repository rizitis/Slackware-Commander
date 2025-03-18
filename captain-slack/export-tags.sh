#!/bin/bash
# shellcheck disable=SC2034

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

# Create or clear the output directory
output_dir="$PKG_DB/P_TAGS" # this dir contains files for every repo with its installed packages in
mkdir -p "$output_dir"

# Clear any existing files in the output directory
rm -f "$output_dir"/*

# Loop through each installed package file in the specified directory
for package in /var/lib/pkgtools/packages/*; do
    # Get the filename without the path
    package_name=$(basename "$package")

    # Split the package name by '-' into an array
    IFS='-' read -r -a parts <<< "$package_name"

    # Count the number of parts
    num_parts=${#parts[@]}

    # Initialize variables for the last few components
    version=""
    arch=""
    build_version=""
    tag=""
    app_name=""

    # Check if there are at least four parts (to expect arch, version, and build_version)
    if [ "$num_parts" -ge 4 ]; then
        build_version="${parts[-1]}"
        arch="${parts[-2]}"
        version="${parts[-3]}"
        # Join the rest as the app name, using a hyphen instead of space
        app_name=$(IFS=-; echo "${parts[*]:0:$(($num_parts-3))}")

        # Check for an optional tag (underscore in build_version)
        if [[ "$build_version" == *_* ]]; then
            tag="${build_version#*_}"   # Extract tag from build_version
            build_version="${build_version%_*}" # Remove tag from build_version
        elif [[ "$build_version" =~ [a-zA-Z] ]]; then
            # If the build_version contains letters, treat those letters as the tag
            tag=$(echo "$build_version" | grep -o '[a-zA-Z]*')
        fi

        # Determine the output filename
        if [[ -n $tag ]]; then
            tag_file_name="${tag//_/}" # Remove underscores from the tag for the filename
            echo "${app_name}" >> "$output_dir/${tag_file_name}.txt" # Output only the package name
        else
            echo "${app_name}" >> "$output_dir/system.txt" # No '=' sign, just the package name
        fi
    elif [ "$num_parts" -eq 3 ]; then
        # Handle cases with only 3 parts (assumed to be app_name-version-architecture)
        app_name="${parts[0]}"
        version="${parts[1]}"
        arch="${parts[2]}"
        build_version="1"  # Default build version if not provided

        # Output to system.txt for no tag, without '='
        echo "${app_name}" >> "$output_dir/system.txt"

    else
        # Handle unexpected format
        echo "Unexpected package format: $package_name" >> "$output_dir/system.txt"
    fi
done

# Notify user of completion
echo "Files created in the '$output_dir' directory."

