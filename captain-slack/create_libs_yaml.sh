#!/bin/bash

# Define the input file and output file
input_file="$PKG_DB/library_dependencies.txt"
output_file="$PKG_DB/libraries_dependencies.yaml"

# Check if the input file exists
if [[ ! -f $input_file ]]; then
    echo "Input file '$input_file' not found!"
    exit 1
fi

# Initialize the output with system information
date_info=$(date)
hostname_info=$(hostname)
arch_info=$(uname -m)
version_info=$(cat /etc/*version* 2>/dev/null | tr '\n' ' ')  # Suppress errors if version files are not found

# Add system information to output
output="date: \"$date_info\"\n"
output+="hostname: \"$hostname_info\"\n"
output+="arch: \"$arch_info\"\n"
output+="version: \"$version_info\"\n"
output+="libraries:\n"  # Start the libraries section

current_lib=""

# Read input line by line from the specified file
while IFS= read -r line; do
    # Check for lines indicating a library being processed
    if [[ $line == NEEDED\ by\ * ]]; then
        # If there's a current library being processed, output it
        if [[ -n $current_lib ]]; then
            output+="  - name: \"$current_lib\"\n"  # Library name without indentation
        fi
        current_lib="${line#NEEDED by }"  # Extract library name
    elif [[ $line == *' => '* ]]; then  # Match lines that show required libraries
        dep_name="${line%% =>*}"  # Extract the dependency name
        # Append the dependency in the specified format
        output+="    dependencies:\n"  # Add dependencies key for the current library
        output+="      - $dep_name => ${line#*' => '}\n"  # Indent for the dependency
    fi
done < "$input_file"  # Read from the specified input file

# Output the last library processed if it's not empty
if [[ -n $current_lib ]]; then
    output+="  - name: \"$current_lib\"\n"  # Add the last library name without indentation
fi

# Write the output to the specified output file
echo -e "$output" > "$output_file"

# Optional: Print a message indicating where the output is saved
echo "Output written to '$output_file'"

sed  -i 's/\t/ /g' "$output_file"
