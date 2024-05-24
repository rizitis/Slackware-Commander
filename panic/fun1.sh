#!/bin/bash

PS1='C:\\\> '

while true; do
    read -e -p "C:\\>" input
    exec "$input" &
done
