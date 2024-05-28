#!/bin/bash

# Make it beautiful, define ANSI escape codes for colors and formatting
bold=$(tput bold)
normal=$(tput sgr0)
green=$(tput setaf 2)  
red=$(tput setaf 1)
wtf=$(tput setaf 5)


# Select a service from /etc/rc.d/
echo -e "${bold}${green}Select a service to manage:${normal}"

select serv in $(ls /etc/rc.d/); do
    if [ -n "$serv" ]; then
echo -e "${bold}${red}service permissions:${normal}"  
stat -c "%A %a %n" /etc/rc.d/"$serv"
        break
    else
        echo -e "${bold}${wtf}Invalid selection. Please try again.${normal}"
    fi
done

# Define the init script for the selected service
init_script="/etc/rc.d/$serv"

# check the status of the selected service
check_status() {
    if [ -x "$init_script" ]; then
        if  $init_script status > /dev/null; then
            echo "$serv is running."
        else
            echo "$serv is not running."
        fi
    else
        echo -e "${bold}${wtf}Init script for $serv not found or not executable.${normal}"
    fi
}

# stop service
stop_service() {
    if [ -x "$init_script" ]; then
        if  $init_script status > /dev/null; then
             $init_script stop
            echo "$serv has been stopped."
        else
            echo "$serv is not running."
        fi
    else
        echo -e "${bold}${wtf}Init script for $serv not found or not executable.${normal}"
    fi
}

# restart service
restart_service() {
    if [ -x "$init_script" ]; then
        if  $init_script status > /dev/null; then
             $init_script restart
             wait
            echo "$serv has been restarted."
        else
            echo "$serv is not running. Starting $serv..."
             $init_script start
        fi
    else
        echo -e "${bold}${wtf}Init script for $serv not found or not executable.${normal}"
    fi
}


check_status
stop_service
restart_service

