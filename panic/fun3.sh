#!/bin/bash

# Set the terminal prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Set the terminal colors
printf '\033]50;SetProfile=macOS\a'
printf '\033]10;#000000\a'
printf '\033]11;#FFFFFF\a'
printf '\033]4;0;#000000\a'
printf '\033]4;1;#C91B00\a'
printf '\033]4;2;#00A94F\a'
printf '\033]4;3;#C9A100\a'
printf '\033]4;4;#0066FF\a'
printf '\033]4;5;#C800A9\a'
printf '\033]4;6;#00A9C9\a'
printf '\033]4;7;#C9C9C9\a'
printf '\033]4;8;#6C6C6C\a'
printf '\033]4;9;#FF3300\a'
printf '\033]4;10;#00CC66\a'
printf '\033]4;11;#FFD000\a'
printf '\033]4;12;#0066FF\a'
printf '\033]4;13;#CC00FF\a'
printf '\033]4;14;#00CCCC\a'
printf '\033]4;15;#FFFFFF\a'
