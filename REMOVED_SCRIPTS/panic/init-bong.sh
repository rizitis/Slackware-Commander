#!/bin/bash

#required cmatrix from SBo

output=$(ps -p 1 -o comm=)


animate_message() {
    message="$1"
    length=${#message}
    for ((i = 0; i < length; i++)); do
        echo -n "${message:$i:1}"
        sleep 0.05
    done
    echo
}

if [ "$output" = "init" ]; then
    clear   
    sleep 1  


    echo -e "\e[1;32mYOU ARE IN SYSVINIT!!!!\e[0m"
    sleep 1
    cmatrix -b -C red  

    clear   
    sleep 1


    animate_message "Congratulations!"
    sleep 1
    animate_message "You've unlocked a secret!"
    sleep 1
    animate_message "Your system is fabulous!"
    sleep 1
    animate_message "LONG LIVE SLACKWARE"
    sleep 2
    clear  


    sleep 1
    echo "   )        )                )"
    sleep 0.5
    echo "  (        (                ("
    sleep 0.5
    echo "   )        )                )"
    sleep 0.5
    echo "  (        (                ("
    sleep 0.5
    echo "   )  .mMMMm .mM     mMM    )   .mMMMm  m mm"
    sleep 0.5
    echo "  (  m     m   #     #  m   (  m        #\"  \""
    sleep 0.5
    echo "   )  #\"#  \"#\"     \"#\"  \"   )  #\"#\"  \"#\" ##"
    sleep 0.5
    echo "  (   \"#\"     \"#   #\"      (   \"#\"     \"#\" \""
    sleep 0.5
    echo "   )    \"W\"   \"M M\"       )   \"W\"     \"M\" mm"
    sleep 0.5
    echo "  (                       ("
    sleep 0.5
    echo "   )                       )"
    sleep 0.5
    echo "  (                       ("
else
    animate_message "No secret for you today."
fi

