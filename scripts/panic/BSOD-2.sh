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


echo -e "\033[?25l"
duration=5
end_time=$((SECONDS + duration))

while [ $SECONDS -lt $end_time ]; do
    echo -e "~~>"
    sleep 0.5
    echo -e "\033[3D<~~"
    sleep 0.5
done

animate_text() {
    local text="$1"
    local color="$2"

    for ((i=0; i<${#text}; i++)); do
        echo -n -e "$color${text:$i:1}"
        sleep 0.05
    done
    echo ""
}

display_systemd_jokes() {
    local jokes=("Why did the systemd service go to therapy? It had too many issues it couldn't resolve!"
                 "How many systemd developers does it take to change a light bulb? None, it's a feature, not a bug!"
                 "Why did the computer take a yoga class? To improve its systemd balance!"
                 "What's a systemd's favorite song? 'I Will Survive' - it restarts itself every time!")

    local random_index=$((RANDOM % ${#jokes[@]}))
    local BOLD_CYAN="\e[1;36m"
    local RESET="\e[0m"
    
echo -e "${BOLD_CYAN}Systemd Joke:${RESET} ${BOLD_RED}${jokes[$random_index]}${RESET}"
}

echo -ne "\033]11;#0000FF\007"

if command -v systemctl > /dev/null; then
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
    
    echo -e "Hehehe! I like it..."
    echo -e "*** SYSTEM ERROR ***"
    echo -e "A critical error has occurred."
    echo -e "The system will restart in 5 seconds.\e[0m"
    

    if systemctl reboot; then
        echo "System reboot initiated."
    else
        echo "Failed to reboot system."
    fi
else
    echo -e "\e[44m\e[97m *** SYSTEM ERROR NOT FOUND ***"
    echo -e "A critical D ERROR NOT FOUND WTF!!!"
    echo -e "No systemd found...no BSOD :(\e[0m"
    echo -ne "\033]11;#000000\007"
echo ""
   echo ""
      echo ""
    animate_text "Let's joke with" 
    animate_text "systemd! :D" 

    display_systemd_jokes

sleep 5
clear

echo "         ☃️         "
sleep 1

clear

echo -e "          ⛄          \n" \
        "        ❄️⛄❄️        \n" \
        "       ⛄❄️⛄❄️⛄       "

sleep 2

clear

echo -e "           ⛄          \n" \
        "         ❄️⛄❄️        \n" \
        "        ⛄❄️⛄❄️⛄       \n" \
        "       ❄️⛄❄️⛄❄️⛄❄️      "

sleep 3

clear

echo -e "            ⛄            \n" \
        "          ❄️⛄❄️          \n" \
        "         ⛄❄️⛄❄️⛄         \n" \
        "        ❄️⛄❄️⛄❄️⛄❄️        \n" \
        "       ⛄❄️⛄❄️⛄❄️⛄❄️⛄       "

sleep 4

clear

echo "Hope you enjoy the snowman! ❄️☃️"
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
