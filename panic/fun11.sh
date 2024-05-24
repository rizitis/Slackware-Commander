#!/bin/bash

while true; do
    echo -e "\e[?25l" # Hide cursor
    echo -e "\e[1;1H" # Move cursor to top-left corner
    for i in {1..100}; do
        echo -e "\e[48;5;$((i%255))m" # Set background color to cycling color
        echo -n " " # Print space to fill entire row
    done
    echo -e "\e[0m" # Reset color
    sleep 0.01 # Sleep for 10 milliseconds
done

