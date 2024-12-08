#!/bin/bash

seperator() {
    echo "-----------------------------------------"
}

resetConfig() {
    clear
    read -rp "WARNING: This will erase all configuration files, and restart the program as if you were running it for the first time. Do you really want to do this? (Y/N) " yn
    case $yn in
        [yY] )
            seperator
            echo "Okay, resetting config data..."
            rm config.json
            rm .ranbefore
            programInit
            ;;
        [nN] )
            seperator
            echo "Okay, returning to the main menu..."
            programInit
            ;;
    esac
}

mainMenu() {
    clear
    echo "SaveX - An SM64 PC Port Save File Manager"
    seperator
    echo "1) Save to a slot"
    echo "2) Load from a slot"
    echo "3) List available slots"
    echo "4) Delete a slot"
    echo "5) Change save directory"
    echo "6) Reset all configuration data"
    echo "7) Exit"
        
    read -rp "Enter your choice: " choice

    case $choice in
        1)
            save_to_slot
            ;;
        2)
            load_from_slot
            ;;
        3)
            list_slots
            ;;
        4)
            delete_slot
            ;;
        5)
            pathInit
            ;;
        6)
            resetConfig
            ;;
        7)
            exit
            ;;
        *)
            echo "Invalid choice."
            ;;
    esac
}

save_to_slot() {
    seperator
    echo "save"
    seperator
    read -rp "Press any key to return to the main menu..." -n1 -s    
}

load_from_slot() {
    seperator
    echo "load"
    seperator
    read -rp "Press any key to return to the main menu..." -n1 -s  
}

list_slots() {
    seperator
    echo "list"
    seperator
    read -rp "Press any key to return to the main menu..." -n1 -s  
}

delete_slot() {
    seperator
    echo "delete"
    seperator
    read -rp "Press any key to return to the main menu..." -n1 -s  
}

pathInit() {
    seperator
    read -rp "Please input the directory where your save files are located: " savepath

    if [ -d "$savepath" ]; then
        if [ -r "$savepath" ] && [ -w "$savepath" ]; then
            jq --arg path "$savepath" '.savepath = $path' config.json > config.tmp 
            mv config.tmp config.json
            seperator
            read -rp "Save directory changed successfully! Press any key to return to the main menu..." -n1 -s
        else
            echo "Directory is not accessible. Please check permissions."
            seperator
            read -rp "Press any key to return to the main menu..." -n1 -s
        fi
    else
        echo "Directory does not exist. Please enter a valid path."
        seperator
        pathInit
    fi
}


programInit() {
    if [ ! -f "config.json" ]; then
        echo "No configuration file found. Creating new config file..."
        echo "{}" > config.json
    else
        echo "Configuration file found."
    fi

    clear
    if [ ! -f ".ranbefore" ]; then
        touch .ranbefore

        clear
        echo "Welcome to SaveX! Before we begin, we must first set things up."
        echo -e "\nTo start, we'll need to make a configuration file to store the path to your saves."

        pathInit
    else
        mainMenu
    fi
}

while true; do
    programInit
done
