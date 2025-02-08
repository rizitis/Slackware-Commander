#!/bin/bash

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

source_config
print_heading() {
    echo -e "${UNDERLINE}${BOLD}${BLUE}$1${RESET}"
}

# YAML file path
yaml_file="$PKG_DB"/packages.yaml

# Function to search for a package by name
search_package() {
    local package_name="$package"



    # Use yq to find the package details with strict equality
    result=$(yq eval ".[] | select(.package == \"$package_name\")" "$yaml_file")

    # Debugging: print the result of the search
#    echo "Search result: $result"

    # Check if result is empty
if [[ -n "$result" ]]; then
    echo -e "\033[38;5;214mPackage found:\033[0m"
    echo "$result" | /usr/bin/yq
    print_info() {
    echo -e "📦 **$1**\n$2"
}
# Define color codes and formatting
BOLD="\e[1m"
BLUE="\e[34m"
RESET="\e[0m"
UNDERLINE="\e[4m"
GREEN="\e[32m"

cd /var/lib/pkgtools/packages/
echo ""
print_heading() {
    echo -e "${UNDERLINE}${BOLD}${BLUE}$1${RESET}"
}
print_heading "------------------"
for i in $(ls /var/lib/pkgtools/packages/ | grep "^$package_name-[0-9]\+"); do
    cat "/var/lib/pkgtools/packages/$i" | grep SIZE
    echo -e "${BLUE}Custom build REQUIRES:${RESET}"
    cat /usr/doc/"$package_name"-*/slack-required 2>/dev/null | while IFS= read -r line; do
    # Add color to the output
    echo -e "\033[1;33m${line}\033[0m"  # Yellow color
done
done
print_heading "------------------"
#echo -e  "${BOLD}https://github.com/gapan/slackware-deps/tree/15.0/$1.dep:${RESET}"
#curl -sSL https://raw.githubusercontent.com/gapan/slackware-deps/15.0/$1.dep | grep -v "^aaa_libraries" || true
for i in $(ls /var/lib/pkgtools/packages/ | grep "^$package_name-[0-9]\+"); do
    echo -e "${BLUE}$package_name.so file if exist:${RESET}"
    cat /usr/doc/"$package_name"-*/$package_name.so-file 2>/dev/null | while IFS= read -r line; do
    # Add color to the output
    echo -e "\033[1;33m${line}\033[0m"  # Yellow color
done
done
curl --fail --silent https://raw.githubusercontent.com/rizitis/Slackware64-Current-sofiles/refs/heads/main/$package.so-file 2>/dev/null || echo " "
print_heading "------------------"
echo ""
    # Loop through possible image extensions and find the first matching file
    for ext in png jpeg jpg svg; do
        icon_path="$(find /usr/share/ -name "$package"."$ext" -print -quit)"
        [ -n "$icon_path" ] && break  # Exit loop once a match is found
    done

    # Check if an icon was found and display it using chafa
    if [ -n "$icon_path" ]; then
        print_heading "$package icon"
        chafa --symbols block+border-solid -s 10x10 "$icon_path"
    else
        echo "No icon found for package '$package'."
    fi

else
    echo "Package '$package' not found."
fi

}

# Example usage: search for a package by name
pkg_name="$1"  # Take the package name from the first script argument
search_package "$pkg_name"

print_heading "More infos you might find in $PKG_DB :"
LS_COLORS='di=1;34:fi=0;32' ls --color "$PKG_DB"
