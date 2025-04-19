#!/bin/bash

# rizitis 2023
# exec this script in xfce or gnome terminal, konsole, xterm etc will lose some color on print_penguins... 

print_line() {
    local char=$1
    local color=$2
    local length=$3
    printf "\e[38;5;${color}m%*s\e[0m\n" "$length" | tr ' ' "$char"
}

snowfall() {
    local columns=$(tput cols)
    local rows=$(tput lines)

    for ((i = 0; i < rows * columns / 10; i++)); do
        local x=$((RANDOM % columns + 1))
        local y=$((RANDOM % rows + 1))
        echo -e "\e[38;5;255m\033[${y};${x}H*\e[0m"
    done
}

print_tree() {
    local trunk_color=94
    local foliage_color=2

    local height=$1
    local width=$((2 * height - 1))

    for ((i = 1; i <= height; i++)); do
        local spaces=$((height - i))
        local trunk_spaces=$((height / 2))
        local trunk_width=2

        print_line " " "$foliage_color" "$spaces"
        print_line "*" "$foliage_color" "$((2 * i - 1))"
    done

    print_line "||" "$trunk_color" "$trunk_width"
    
sleep 5
}

print_penguins() {
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
        "       ⛄❄️⛄❄️⛄❄️⛄❄️⛄       \n" \
        "            ||                 "

sleep 4

clear

echo "Hope you enjoy the snowman! ❄️☃️"
echo -e "\e[1;31mMerry Christmas, Linux Penguins and Slackware fellows!\e[0m"
sleep 3
text="01010011 01101100 01100001 01100011 01101011 01110111 01100001 01110010 01100101"
smiley=";)"

color="\e[1;32m"

for ((i=0; i<${#text}; i++)); do
    echo -n -e "$color${text:$i:1}"
    sleep 0.05
done
echo ""
echo -e "\e[1;33m$smiley\e[0m"
}

print_greeting() {
    echo -e "\e[1;31mMerry Christmas, Linux Penguins and Slackware fellows!\e[0m"
}

main() {
    clear
    snowfall
    print_greeting
    echo
    print_tree 10  
    echo
    print_penguins
    echo
}

main
