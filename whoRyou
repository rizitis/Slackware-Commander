#!/bin/bash

# Anagnostakis Ioannis 2023
# GNU GENERAL PUBLIC LICENSE
# LONG LIVE SLACKWARE

if [ "root" != "$USER" ]; then
  echo "Enter su"
  su -c "$0" root
  exit
fi

# Define color codes and formatting
BOLD="\e[1m"
BLUE="\e[34m"
RESET="\e[0m"
UNDERLINE="\e[4m"
GREEN="\e[32m"

# Function to display section headings
print_heading() {
    echo -e "${UNDERLINE}${BOLD}${BLUE}$1${RESET}"
}

# Function to display package information
print_info() {
    echo -e "📦 **$1**\n$2"
}

clear
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

mkdir -p /tmp/whoRyou
chmod 600 /tmp/whoRyou
chown root:root /tmp/whoRyou
read -p 'Enter package name: ' pkgvar

clear
echo "─────────────────────────────────────────────────────────────────────────────" > "/tmp/whoRyou/$pkgvar.whoRyou"
print_heading "Hello Slacker, here's the information for package '$pkgvar':" >> "/tmp/whoRyou/$pkgvar.whoRyou"
echo "─────────────────────────────────────────────────────────────────────────────" >> "/tmp/whoRyou/$pkgvar.whoRyou"

# Package Information
print_info "PACKAGE INFORMATION" "If the package is a service, rc.d print will be at the end." >> "/tmp/whoRyou/$pkgvar.whoRyou"
echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
# Package Path
print_info "Package Path" >> "/tmp/whoRyou/$pkgvar.whoRyou"
	which "$pkgvar" >> "/tmp/whoRyou/$pkgvar.whoRyou"
	grep ^bin/"$pkgvar"$ /var/lib/pkgtools/packages/* >> "/tmp/whoRyou/$pkgvar.whoRyou"

# Package Size
print_info "PACKAGE SIZE"  >> "/tmp/whoRyou/$pkgvar.whoRyou"
	echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
cd /var/lib/pkgtools/packages/
echo "─────────────────────────────────────────────────────────────────────────────" 
echo "Select the number of package and hit [enter]"
echo "If package is not listed type 0 (zero) and [enter]"	
echo "─────────────────────────────────────────────────────────────────────────────"
select fpkg in $(ls * | grep "$pkgvar"); do break;done 
if [ "$fpkg" = 0 ]; then
  echo ""  >> "/tmp/whoRyou/$pkgvar.whoRyou"
else
  cat "$fpkg"* | grep SIZE >> "/tmp/whoRyou/$pkgvar.whoRyou"
echo " "  >> "/tmp/whoRyou/$pkgvar.whoRyou"
# When and persmissions
print_info "When..what permissions? " >> "/tmp/whoRyou/$pkgvar.whoRyou"
if [ "$fpkg" = 0 ]; then
 ls -ltr /var/log/packages/ | grep  "$pkgvar"  >> "/tmp/whoRyou/$pkgvar.whoRyou"
else
 ls -ltr /var/log/packages/ | grep "$fpkg" >> "/tmp/whoRyou/$pkgvar.whoRyou"
fi
echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
    # Library Dependencies
print_info "LIBRARY DEPENDENCIES" >> "/tmp/whoRyou/$pkgvar.whoRyou"
	  echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
	  ldd "$(which "$pkgvar")" >> "/tmp/whoRyou/$pkgvar.whoRyou"
	  echo "" >> "/tmp/whoRyou/$pkgvar.whoRyou"
# Service Information (empty in this example)
print_info "SERVICE INFORMATION" "" >> "/tmp/whoRyou/$pkgvar.whoRyou"
	  echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
	  ls -la /etc/rc.d/ | grep "$pkgvar" >> "/tmp/whoRyou/$pkgvar.whoRyou"
	  echo " "  >> "/tmp/whoRyou/$pkgvar.whoRyou"
  # Is it a Library?
  print_info "IS IT A LIBRARY?" >> "/tmp/whoRyou/$pkgvar.whoRyou"
  echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
if [ "$fpkg" = 0 ]; then
    echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
  else
    sudo ldconfig -p | grep "$pkgvar" >> "/tmp/whoRyou/$pkgvar.whoRyou"
 fi
fi
echo " " >> "/tmp/whoRyou/$pkgvar.whoRyou"
print_info "If the full package name = 0, then only **PACKAGE INFORMATION** is correct." >> "/tmp/whoRyou/$pkgvar.whoRyou"
print_info "Other info may not be accurate :)" >> "/tmp/whoRyou/$pkgvar.whoRyou"
print_heading "─────────────────────────────────────────────────────────────────────────────" >> "/tmp/whoRyou/$pkgvar.whoRyou"
echo -e "${BOLD}${BLUE}"
clear
cat /tmp/whoRyou/$pkgvar.whoRyou
icon_path="$(find /usr/share/ -name $pkgvar.png -print -quit)"
wait
        # If a valid icon path is found, display it with catimg
        /usr/bin/catimg -w 60 "$icon_path"
rm -rf /tmp/whoRyou
