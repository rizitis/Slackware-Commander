#!/bin/bash

# Define the dimensions of the terminal
screen_width=$(tput cols)
screen_height=$(tput lines)

# Set the number of stars to create
num_stars=100

# Create an array to hold the stars
declare -a stars

# Generate the stars
for (( i=0; i<$num_stars; i++ )); do
  # Generate a random position and speed for the star
  x=$(( RANDOM % $screen_width ))
  y=$(( RANDOM % $screen_height ))
  speed=$(( (RANDOM % 10) + 1 ))

  # Add the star to the array
  stars[$i]="$x $y $speed"
done

# Move the stars across the screen
while true; do
  # Clear the screen
  clear

  # Move each star
  for (( i=0; i<$num_stars; i++ )); do
    # Get the current position and speed of the star
    read x y speed <<< "${stars[$i]}"

    # Update the position of the star
    x=$(( x + speed ))
    if (( x >= screen_width )); then
      x=$(( x - screen_width ))
    fi

    # Update the array with the new position of the star
    stars[$i]="$x $y $speed"

    # Print the star at its new position
    tput cup $y $x
    echo -n "*"
  done

  # Wait for a short time before moving the stars again
  sleep 0.1
done

