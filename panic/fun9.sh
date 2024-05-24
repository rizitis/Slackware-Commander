#!/bin/bash

clear

# Define the airplane ASCII art
AIRPLANE="    __|__"
AIRPLANE1="--@--(_)--@--"
# Define the starting position of the airplane
POS=0

# Loop through the animation
while true; do
  # Move the airplane one position to the right
  POS=$((POS+1))

  # Clear the screen and redraw the airplane
  clear
  printf "%${POS}s$AIRPLANE\n" ""
   printf "%${POS}s$AIRPLANE1\n" ""
  # Pause for a short time
  sleep 0.05

  # Check if the airplane has reached the end of the screen
  if [ $POS -eq $(tput cols) ]; then
    break
  fi
done

# Print a message when the animation ends
echo "The airplane has landed!"
echo "In fact, half of it..."
