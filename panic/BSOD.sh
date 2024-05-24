#!/bin/bash

interrupt_handler() {
    echo "\./"
}

trap interrupt_handler SIGINT

echo -ne "\033]11;#0000FF\007"
echo " Check if systemd is installed"
interrupt_handler() {
    echo -e "\033[?25h"  
    exit 0
}

trap interrupt_handler SIGINT

echo -e "\033[?25l"
duration=5
end_time=$((SECONDS + duration))

while [ $SECONDS -lt $end_time ]; do
    echo -e "~~>"
    sleep 0.5
    echo -e "\033[3D<~~"
    sleep 0.5
done

echo -e "\033[?25h"
if command -v systemctl > /dev/null; then
    echo -e "Hehehe! I like it..."
    echo -e "*** SYSTEM ERROR ***"
    echo -e "A critical error has occurred."
    echo -e "The system will restart in 5 seconds.\e[0m"
    sleep 5
systemctl reboot
else
    echo -e "\e[44m\e[97m *** SYSTEM ERROR NOT FOUND***"
    echo -e "A critical D ERROR NOT FOUND WTF!!!"
    echo -ne "\033]11;#000000\007"
    echo -e "No systemd found...no BSOD :(\e[0m"
echo ""
text="01010011 01101100 01100001 01100011 01101011 01110111 01100001 01110010 01100101"
smiley=";)"

color="\e[1;32m"

for ((i=0; i<${#text}; i++)); do
    echo -n -e "$color${text:$i:1}"
    sleep 0.05
done
echo ""
echo -e "\e[1;33m$smiley\e[0m"
fi
