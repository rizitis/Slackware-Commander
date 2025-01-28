#!/bin/bash

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

# Output file
output_file="$PKG_DB"/"installed_packages.txt"
mkdir -p "$PKG_DB" || exit 99
# Create or clear the output file
touch "$output_file"
echo "" > "$output_file"

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

        # Check for an optional tag
        if [[ "$build_version" == *_* ]]; then
            tag="${build_version#*_}"   # Extract tag from build_version
            build_version="${build_version%_*}" # Remove tag from build_version
        fi

        # Output the formatted package information
        if [[ -n $tag ]]; then
            echo "Package: $app_name, Version: $version, Architecture: $arch, Build Version: $build_version, Tag: $tag" >> "$output_file"
        else
            echo "Package: $app_name, Version: $version, Architecture: $arch, Build Version: $build_version" >> "$output_file"
        fi
    elif [ "$num_parts" -eq 3 ]; then
        # Handle cases with only 3 parts (assumed to be app_name-version-architecture)
        app_name="${parts[0]}"
        version="${parts[1]}"
        arch="${parts[2]}"
        build_version="1"  # Default build version if not provided

        # Output the formatted package information
        echo "Package: $app_name, Version: $version, Architecture: $arch, Build Version: $build_version" >> "$output_file"
    else
        # Handle unexpected format
        echo "Unexpected package format: $package_name" >> "$output_file"
    fi
done

# Get list of installed Flatpak apps with full app ID, name, version, and origin
flatpak_list=$(flatpak list --app --columns=application,name,version,origin)

# Skip the header (first line)
echo "$flatpak_list" | tail -n +2 | while IFS=$'\t' read -r app_id name version origin
do
    # Remove leading/trailing whitespace from the variables
    app_id=$(echo "$app_id" | xargs)
    name=$(echo "$name" | xargs)
    version=$(echo "$version" | xargs)
    origin=$(echo "$origin" | xargs)

    # Get architecture
    arch=$(flatpak info "$app_id" | grep "Arch:" | awk '{print $2}')
    
    # Set a static build version
    build_version="1"
    
    # Print in the desired format
    echo -e "Package: $name, Version: $version, Architecture: $arch, Build Version: $build_version, Tag: $origin" >> "$output_file"
done
