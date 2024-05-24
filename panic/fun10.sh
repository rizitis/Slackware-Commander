#!/bin/bash

# Check if required packages are installed
if ! command -v aafire &> /dev/null; then
    echo "This script requires aafire and sox."
    echo "Please install them and try again."
    exit 1
fi

# Pipe audio input to aafire
sox -d -n -p rate 8000 synth 3 sine 800 | aafire

