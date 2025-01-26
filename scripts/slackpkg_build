#!/bin/bash


# slackpkg_build download and build officially Slackware packages
# Anagnostakis Ioannis GR 04/2024 <rizitis@gmail.com>
# No copyrights

# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ''AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Check if a package name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <package>"
  exit 1
fi

package="$1"

echo -e "\e[1;34m"
cat << "EOF"
                                                        
  ██████  ██▓    ▄▄▄       ▄████▄   ██ ▄█▀ █     █░ ▄▄▄       ██▀███  ▓█████  
▒██    ▒ ▓██▒   ▒████▄    ▒██▀ ▀█   ██▄█▒ ▓█░ █ ░█░▒████▄    ▓██ ▒ ██▒▓█   ▀  
░ ▓██▄   ▒██░   ▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ ▒█░ █ ░█ ▒██  ▀█▄  ▓██ ░▄█ ▒▒███    
 ▒   ██▒▒██░   ░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄  ░█░ █ ░█ ░██▄▄▄▄██ ▒██▀▀█▄  ▒▓█  ▄   
▒██████▒▒░██████▒▓█   ▓██▒▒ ▓███▀░▒██▒ █▄░░██▒██▓  ▓█   ▓██▒░██▓ ▒██▒░▒████▒ 
▒ ▒▓▒ ▒ ░░ ▒░▓  ░▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒░ ▓░▒ ▒   ▒▒   ▓▒█░░ ▒▓ ░▒▓░░░ ▒░ ░ 
░ ░▒  ░ ░░ ░ ▒  ░ ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░  ▒ ░ ░    ▒   ▒▒ ░  ░▒ ░ ▒░ ░ ░  ░ 
░ ░  ░    ░ ░    ░   ▒   ░        ░ ░░ ░   ░   ░    ░   ▒     ░░   ░    ░    
  ░      ░  ░     ░  ░░ ░      ░  ░       ░          ░  ░   ░        ░  ░ 
                         ░                                             
                                                                        

EOF
echo -e "\e[0m"
echo -e "${RESET}"

# Color codes
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RESET='\033[0m'
# Check if the script is being run as root,because never is to late...LOL
if [ "$(id -u)" -ne 0 ]; then
  echo -e "${RED}Error: I dont know why, but this script must be run as root :*${RESET}"
  exit 1
fi

# Load the Slackware mirror from /etc/slackpkg/mirrors
mirror_url=$(grep -v '^#' /etc/slackpkg/mirrors | head -n 1 | tr -d ' ')



if [[ ! "$mirror_url" =~ ^http ]]; then
  echo -e "${RED}Error: Invalid Slackware mirror URL.${RESET}"
  exit 1
fi

# URL for FILE_LIST
file_list_url="${mirror_url}source/FILE_LIST"

# Create a temporary directory downloaded FILE_LIST
tmp_dir=$(mktemp -d)
if [ ! -d "$tmp_dir" ]; then
  echo -e "${RED}Error: Could not create temporary directory.${RESET}"
  exit 1
fi

# Download FILE_LIST
wget -O "${tmp_dir}/FILE_LIST" "$file_list_url" || {
  echo -e "${RED}Error: Could not download FILE_LIST from $file_list_url.${RESET}"
  exit 1
}

# Yes I know...
extensions="\(\.new\|\.d\|\.rpm\|\.deb\|\.rules\|\.pc\|\.clr\|\.xz\|\.lz\|\.gz\|\.png\|\.jpg\|\.jpeg\|\.diff\|slack-desc\|\.url\|\.asc\|\.desktop\|\.sample\|\.sh\|\.gem\|\.sign\|\.patch\|\.bz2\|\.conf\|\.awk\|\.tgz\|\.lsm\|\.md\|\.slackpkg\|\.tar\|\.bmp\|\.dat\|\.initrd\|\.README\|\.c\|\.logrotate\|\.functions\|\.default\|\.local\|\.sgml\|\.atd\|\.info\|\.txt\|\.zip\|\.zst\|\.md5\|\.TXT\|\.example\|\.m4\|\.tlpkg\|\.texmf\|\.fontconfig\|\.build\|\.xpm\|\.pam\|\.csh\|\.opts\|\.sig\)$"

# Use sed to delete lines ending with specified extensions
# $wait is a must or boom...#
sed -i "/$extensions/d" "${tmp_dir}/FILE_LIST"
wait
sed -i '/patches\|slack-desc\|README/d' "${tmp_dir}/FILE_LIST"
wait
sed -i '/^\s*$/d' "${tmp_dir}/FILE_LIST"
wait
sed -i 's/^[^.]*\.//' "${tmp_dir}/FILE_LIST"
wait


package_identifier="$1"
# This must be better...anyway.
package_folder=$(grep /"$package_identifier$" "${tmp_dir}/FILE_LIST" | head -n 1)

if [ -z "$package_folder" ]; then
  echo "Error: No exact match found for '$package_identifier'."
  exit 1
fi


# Λήψη του αρχείου με τα dependencies
URL="https://raw.githubusercontent.com/gapan/slackware-deps/15.0/$1.dep"
DEPS=$(curl -sSL $URL | grep -v "^aaa_libraries")

# Έλεγχος αν το αρχείο υπάρχει και δεν είναι κενό
if [ -z "$DEPS" ]; then
  echo "NO dependencies found for $1."
  sleep 3 
else
  # Εμφάνιση της λίστας των dependencies και έλεγχος αν είναι εγκατεστημένα
  echo "Following dependencies required for $1:"
  for dep in $DEPS; do
    if ! ls /var/lib/pkgtools/packages | grep -q "$dep"; then
      echo -e "${RED} $dep is not installed.${RESET}"
    else
      echo -e "${GREEN} $dep is already installed.${RESET}"
    fi
  done
  
  # Ερώτηση για το αν θέλει να συνεχίσει
  while true; do
    read -p "Do you want to continue? (y/n): " yn
    case $yn in
        [Yy]* ) echo "Continuing..."; break;;
        [Nn]* ) echo "Exiting..."; exit;;
        * ) echo "Please type y/n.";;
    esac
  done
fi


# well...
if [[ "$package_folder" == *"/kde/kde/"* ]]; then
  echo -e "${RED}I'm sorry, KDE apps are not supported for separate building.${RESET}"
  echo -e "${RED}You must download the entire KDE project.${RESET}"
  echo -e "${GREEN} ${mirror_url}source/kde/kde/${RESET}"
  exit 1
fi

# ...
if [[ "$package_folder" == *"/x/x11/"* ]]; then
  echo -e "${RED}I'm sorry, X11 files are not supported for separate building.${RESET}"
  echo -e "${RED}You must download the entire X11 project.${RESET}"
  echo -e "${GREEN} ${mirror_url}source/x/x11/${RESET}"
  exit 1
fi


# Display the search result with a clear section header
echo -e "${BLUE}Finding Remote Path for: ${GREEN}$package_identifier${RESET}"
echo -e "${BLUE}=========================${RESET}"
echo -e "Path: ${GREEN}$package_folder${RESET}"
echo -e "${BLUE}=========================${RESET}\n"

# μπαμπά μην τρέχεις...
if [ -z "$package_folder" ]; then
  echo -e "${RED}Error: Package folder for '$package' not found in FILE_LIST.${RESET}"
  exit 1
fi

# source URL for the package
source_url="${mirror_url}source${package_folder}"


# Create a directory for downloading the package source
download_dir="/tmp/slackpkg-build"
mkdir -p "$download_dir" || {
  echo -e "${RED}Error: Could not create directory $download_dir.${RESET}"
  exit 1
}

# Set strict permissions to ensure only root can access it
chmod 600 "$download_dir" || {
  echo -e "${RED}Error: Could not set permissions for $download_dir.${RESET}"
  exit 1
}
chown root:root "$download_dir"

# Download the package source folder
cd "$download_dir" || exit 1
lftp -c "mirror $source_url" || {
  echo -e "${RED}Error: Could not download package source from $source_url.${RESET}"
  exit 1
}

# Indicate that the package has been downloaded
echo -e "${GREEN}Package Downloaded${RESET}"
echo -e "${BLUE}===================${RESET}"
echo -e "${GREEN}$package has been successfully downloaded.${RESET}"
echo -e "${BLUE}===================${RESET}\n"

# list of downloaded files
echo -e "${GREEN}Files in $download_dir for package $package:${RESET}"
echo -e "${BLUE}===================${RESET}"
ls "$download_dir"/"$package"
echo -e "${BLUE}===================${RESET}\n"

# additional information for building the package
echo -e "${RED}Important Information${RESET}"
echo -e "${BLUE}===================${RESET}"
echo -e "If ${GREEN}$package.SlackBuild${RESET} is not visible, you can't build the package."
echo -e "It might be part of a larger project that builds multiple files with one SlackBuild."
echo -e "You can find more informations:${GREEN} ${mirror_url}source${package_folder}${RESET}"
echo -e "${BLUE}===================${RESET}\n"

# Loop until a valid response is provided
while true; do

    read -p "$(echo -e "Do you want to build or stop? (yes/no):")" answer

    # Convert response to lowercase for consistency
    answer=$(echo "$answer" | tr '[:upper:]' '[:lower:]')

    # Handle "yes" response
    if [[ "$answer" == "y" || "$answer" == "yes" ]]; then
        echo -e "${BLUE}Building the package...${RESET}"
        
        # Make the SlackBuild script executable
        slackbuild_script="$download_dir/"$1"/${package}.SlackBuild"
        chmod +x "$slackbuild_script" || {
          echo -e "${RED}Error: Could not make SlackBuild script executable.${RESET}"
          echo -e "${RED}Error: DID you download a DIR or a package with no SlackBuild?.${RESET}"
          exit 1
        }

        # Run the SlackBuild script to build the package
        bash "$slackbuild_script" || {
          echo -e "${RED}Error: Failed to build the package.${RESET}"
          exit 1
        }

        break  
    elif [[ "$answer" == "n" || "$answer" == "no" ]]; then
        echo -e "${BLUE}Stopping the build progress.${RESET}"
        echo -e "${BLUE}You may continue in /tmp/slackpkg-build/$package ${RESET}"
        exit 0  # Stop the script if the user says "no"
    else
        echo -e "${RED}Invalid response. Please enter 'yes' or 'no'.${RESET}"
        # Loop will continue for an invalid response
    fi
done

echo -e "${GREEN}Package '$package' built successfully.${RESET}"
echo -e "${BLUE}Binary stored in /tmp/slackpkg-build/$package, ready for installation.${RESET}"

# Cleanup
rm -rf "$tmp_dir"
