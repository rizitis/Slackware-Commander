#!/bin/bash

# Define the words and their colors
words=("SLACKWARE" "SINCE" "1993" "THE" "ONE" "AND" "ONLY" "KISS" "LINUX" "DISTRO" "LONG" "LIVE" "SLACKWARE" "LONG" "LIVE" "SLACKWARE" "THE" "REAL" "GNU" "LINUX" "DISTRO" "K" "I" "S" "S" )
colors=("\e[1;31m" "\e[1;32m" "\e[1;33m" "\e[1;34m" "\e[1;35m" "\e[1;36m" "\e[1;37m")

# Get the width of the terminal window
width=$(tput cols)

# Define the starting positions for each word
positions=()
for (( i=0; i<${#words[@]}; i++ ))
do
  positions+=($((-${#words[i]})))
done

# Loop until all words reach the end of the screen
while [[ ${positions[0]} -lt $width ]]
do
  # Clear the screen
  clear

  # Print each word at its current position with its color
  for (( i=0; i<${#words[@]}; i++ ))
  do
    # Get the color index based on the word index
    color_index=$((i % ${#colors[@]}))

    # Print the word at the current position with its color
    printf "%${positions[i]}s${colors[color_index]}${words[i]}\e[0m "

    # Increment the position
    ((positions[i]++))
  done

  # Wait for a short time
  sleep 0.1
done

# Print the final positions of the words
for (( i=0; i<${#words[@]}; i++ ))
do
  # Get the color index based on the word index
  color_index=$((i % ${#colors[@]}))

  # Print the word at the final position with its color
  printf "%${positions[i]}s${colors[color_index]}${words[i]}\e[0m "
done

# Print a new line
printf "\n"

sleep 7
neofetch

