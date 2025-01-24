#!/bin/bash

# Define the UFO ASCII art
ufo=(
"      .       "
"   \\  |  /    "
"  -- @ --     "
"   /  |  \\    "
"      '       "
)

# Define the dimensions of the terminal window
width=$(tput cols)
height=$(tput lines)

# Define the initial position of the UFO
x=$width
y=$((height / 2))

# Define the UFO speed
speed=2

# Loop indefinitely
while true; do
    # Move the UFO
    x=$((x - speed))

    # If the UFO goes off the left edge of the screen, wrap around to the right
    if ((x < 0)); then
        x=$width
    fi

    # Clear the screen
    clear

    # Print the UFO at its current position
    for ((i = 0; i < ${#ufo[@]}; i++)); do
        tput cup $((y + i)) $x
        echo "${ufo[$i]}"
    done

    # Sleep for a short time to control the animation speed
    sleep 0.1
done
