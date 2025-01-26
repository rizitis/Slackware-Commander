#!/bin/bash

trap "echo 'This script cannot be killed with Ctrl+C!'" SIGINT
trap "" SIGHUP

while true; do
    echo "Press Ctrl+C to see the message"
    sleep 1
done
