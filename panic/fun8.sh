#!/bin/bash

clear

# Define the characters and their starting positions
CHAR1="DEB"
CHAR2="RPM"
CHAR3="SLACKWARE"
POS1=0
POS2=10
POS3=20

# Loop through the animation
while true; do
  # Move the characters one position to the right
  POS1=$((POS1+1))
  POS2=$((POS2+1))
  POS3=$((POS3+1))

  # Clear the screen and redraw the characters
  clear
  printf "%${POS1}s$CHAR1\n" ""
  printf "%${POS2}s$CHAR2\n" ""
  printf "%${POS3}s$CHAR3\n" ""

  # Pause for a short time
  sleep 0.1

  # Check if any of the characters have reached the end of the screen
  if [ $POS1 -eq $(tput cols) ] || [ $POS2 -eq $(tput cols) ] || [ $POS3 -eq $(tput cols) ]; then
    break
  fi
done

# Print a message when the animation ends
echo "The race was over... Before 30 years!"
sleep 3
neofetch
