#!/bin/bash

# Set initial coordinates for the UFO
x=0
y=0

# Define the shape of the UFO
ufo=(
"    .-^-."
"  .'=^=^='."
"=/:5 5 5 :\="
"|:  :  :  :|"
" \:  :  :  ;/"
"  `._`='_.'"
"     `~~`"
)

# Define function to move the UFO
move_ufo() {
    # Clear the screen
    clear

    # Calculate the new coordinates
    x=$((x + 1))
    y=$((y + 1))

    # Print the UFO at the new coordinates
    for i in "${ufo[@]}"; do
        tput cup $y $x
        echo "$i"
        y=$((y + 1))
    done

    # Set a delay between movements
    sleep 0.1
}

# Hide the cursor
tput civis

# Continuously move the UFO until the script is interrupted
while true; do
    move_ufo
done

# Show the cursor again
tput cvvis

