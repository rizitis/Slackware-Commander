#!/bin/bash

# SLACKWARE LINUX, 30 χρόνια Ανθρώπινη Νοημοσύνη.

fireworks() {
    local width=$(tput cols)
    local height=$(tput lines)

    tput civis 

    for i in {1..30}; do
        local color=$((31 + (i % 7))) 

        for j in {1..100}; do
            local x=$((RANDOM % width))
            local y=$((RANDOM % height))

            echo -ne "\e[${y};${x}H\e[1;${color}m*\e[0m"
        done

        sleep 0.05
    done

    tput cnorm 
}

display_message() {
    local message="Happy 30th Birthday SLACKWARE LINUX!"

    echo -e "\e[33m" 

    local width=$(tput cols)
    local height=$(tput lines)
    local x=$(( (width - ${#message}) / 2 ))
    local y=$(( height / 2 ))

    echo -ne "\e[${y};${x}H${message}"
    echo -e "\e[0m"  
}

main() {
    fireworks
    display_message
}

main
