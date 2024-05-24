#!/bin/bash

if ! command -v cacademo &> /dev/null; then
    echo "This script requires libcaca and cacademo."
    echo "Please install them and try again."
    exit 1
fi

echo "Press Ctrl+C to stop the animation."

while true; do
    # Generate a random fire palette
    palette=$(shuf -i 16-231 -n 3 | sort -n | tr '\n' ' ' | sed 's/ $//')
    cacademo -T ansi -f fire -s $palette
done

