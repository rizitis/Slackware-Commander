#!/bin/bash

trap 'handle_ctrl_c' INT

handle_ctrl_c() {
clear           # Clear the screen
  tput cnorm      # Show the cursor
  echo "LONG LIVE SLACKWARE"
}

while true; do
  tput cnorm  # Show the cursor
  tput cuu1   # Move cursor up 1 line
  sleep 0.5
  tput cud1   # Move cursor down 1 line
  sleep 0.5
  tput cuf1   # Move cursor right 1 character
  sleep 0.5
  tput cub1   # Move cursor left 1 character
  sleep 0.5
  tput civis  # Hide the cursor
done
