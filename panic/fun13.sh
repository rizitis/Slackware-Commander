#!/bin/bash

# Set terminal background color to black
printf '\033[40m'

# Get terminal dimensions
rows=$(tput lines)
cols=$(tput cols)

# Hide cursor
printf '\033[?25l'

# Fill screen with random green digits
while true; do
    for ((i=1;i<=rows;i++)); do
        for ((j=1;j<=cols;j++)); do
            r=$(($RANDOM % 10))
            if [ $r -eq 0 ]; then
                printf '\033[32m'
            else
                printf '\033[32;2m'
            fi
            printf '%s' "${r}"
        done
        printf '\n'
    done
    sleep 0.1
done

# Show cursor
printf '\033[?25h'

