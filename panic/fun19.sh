#!/bin/bash

# Set the password length
password_length=128

# Generate the password
password=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c $password_length ; echo '')

# Print the password
echo ""
echo "This is a length=128 password: $password"
echo ""
wait

password_length=16
echo "This error giving the best password ;)"
password=$(head /dev/urandom | tr -dc A-Za-z0-9!@#$%^&*@#}{ | head -c $password_length ; echo '')

echo ""
echo ""
echo ""
echo "This is a length=16 password: $password"

echo ""
echo ""
echo "Which you think is more strong?"
echo ""


# Set colors
red="\e[31m"
green="\e[32m"
yellow="\e[33m"
reset="\e[0m"

# Print message
echo -e "${red}╔══════════════════════════════╗${reset}"
echo -e "${red}║${reset}    Have a nice ${green}Slacky${reset} day!    ${red}║${reset}"
echo -e "${red}╚══════════════════════════════╝${reset}"
echo -e "${yellow}"
echo -e "       ."
echo -e "       .'
       .               |    | 
                    \\\   /    
         \\\    _\\__|_\__/    
        \\\__-'     /--'Z       
         \'--._\\__/         
                \\\ |       .    
                 \\\|      /     
         jgs_     \/    -<      
           /\\___/\\/_     \\\    
        /\(  o   o  )                  | 
       |   \\\"\"\"/    \\\                 |  
        \\__|\\0/|__/
        \\\   /\\\   /      
         \\\ /  \\\ /      U${reset}"


