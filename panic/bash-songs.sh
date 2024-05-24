#!/bin/bash

clear

# Function to print a bubble with random color at the specified position
print_colored_bubble() {
    local x=$1
    local y=$2
    local color_code=$((31 + RANDOM % 7))  # ANSI color codes (31-37) for different colors
    tput cup $y $x
    printf "\e[${color_code}m○\e[0m"  # Apply color and reset
}

# Function to play a random sound effect
play_random_sound() {
    local sound_directory="/usr/share/sounds"  # Adjust the sound directory path
    local sound_files=($(find "$sound_directory" -type f))
    local random_sound="${sound_files[RANDOM % ${#sound_files[@]}]}"
    canberra-gtk-play -f "$random_sound"
}

# Animation loop
while true; do
    # Clear the previous frame
    clear

    # Terminal size
    rows=$(tput lines)
    cols=$(tput cols)

    # Bubble positions and directions
    declare -A bx
    declare -A by
    declare -A dx
    declare -A dy
    for i in {0..2}; do
        bx[$i]=$((RANDOM % (cols - 3) + 2))
        by[$i]=$((RANDOM % (rows - 3) + 2))
        dx[$i]=$((RANDOM % 2 * 2 - 1))
        dy[$i]=$((RANDOM % 2 * 2 - 1))
    done

    # Animation frames
    for ((frame = 0; frame < 50; frame++)); do
        for i in {0..2}; do
            print_colored_bubble ${bx[$i]} ${by[$i]}
            bx[$i]=$((bx[$i] + dx[$i]))
            by[$i]=$((by[$i] + dy[$i]))

            # Bounce off the walls
            if [[ ${bx[$i]} -le 0 || ${bx[$i]} -ge $((cols - 2)) ]]; then
                dx[$i]=$((-1 * dx[$i]))
                play_random_sound  # Play a sound on bounce
            fi
            if [[ ${by[$i]} -le 0 || ${by[$i]} -ge $((rows - 1)) ]]; then
                dy[$i]=$((-1 * dy[$i]))
                play_random_sound  # Play a sound on bounce
            fi
        done
        sleep 0.1
    done
done
