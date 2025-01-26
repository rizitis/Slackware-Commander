#!/bin/bash

clear

echo -e "\n\033[1;38;5;226mTuning in to Terminal TV...\033[0m\n"

while true; do
  for (( i=0; i<=9; i++ )); do
    echo -ne "\033[38;5;$((i+16))m.\033[0m"
    sleep 0.1
  done

  for (( i=9; i>=0; i-- )); do
    echo -ne "\033[38;5;$((i+16))m.\033[0m"
    sleep 0.1
  done

  echo -ne "\033[1;38;5;226m_\033[0m"
  sleep 0.5
  echo -ne "\033[1;38;5;226m_\033[0m"
  sleep 0.5
  echo -ne "\033[1;38;5;226m_\033[0m"
  sleep 0.5
  echo -e "\033[1;38;5;226m@\033[0m"

  echo -ne "\033[38;5;226m.\033[0m"
  sleep 0.1
  echo -ne "\033[38;5;226m.\033[0m"
  sleep 0.1
  echo -ne "\033[38;5;226m.\033[0m"
  sleep 0.1

  for (( i=0; i<=9; i++ )); do
    echo -ne "\033[38;5;$((i+16))m.\033[0m"
    sleep 0.1
  done

  for (( i=9; i>=0; i-- )); do
    echo -ne "\033[38;5;$((i+16))m.\033[0m"
    sleep 0.1
  done

  echo -ne "\033[1;38;5;226m_\033[0m"
  sleep 0.5
  echo -ne "\033[1;38;5;226m_\033[0m"
  sleep 0.5
  echo -ne "\033[1;38;5;226m_\033[0m"
  sleep 0.5
  echo -e "\033[1;38;5;226m@\033[0m"

  echo -ne "\033[38;5;226m.\033[0m"
  sleep 0.1
  echo -ne "\033[38;5;226m.\033[0m"
  sleep 0.1
  echo -ne "\033[38;5;226m.\033[0m"
  sleep 0.1

  echo -e "\n\033[38;5;214mLONG LIVE SLACKWARE!!!\033[0m\n"
  sleep 2

  echo -e "\033c"
  echo -e "\n\033[1;38;5;226mTuning in to Terminal TV...\033[0m\n"
done

