#!/bin/bash

source functions.sh
source colors.sh
clear

COLUMNS=$(tput cols)
LINES=$(tput lines)

logo() {
    printf "\n${YELLOW}${BOLD}"
    printf "    ███████╗██╗  ██╗ █████╗ ███╗   ███╗    ██████╗  █████╗ ███╗   ██╗██╗  ██╗    ██████╗ ██████╗ \n"
    printf "    ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║    ██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝    ╚════██╗██╔══██╗\n"
    printf "    █████╗   ╚███╔╝ ███████║██╔████╔██║    ██████╔╝███████║██╔██╗ ██║█████╔╝      █████╔╝██████╔╝\n"
    printf "    ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║    ██╔══██╗██╔══██║██║╚██╗██║██╔═██╗     ██╔═══╝ ██╔═══╝ \n"
    printf "    ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║    ██║  ██║██║  ██║██║ ╚████║██║  ██╗    ███████╗██║     \n"
    printf "    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝    ╚══════╝╚═╝     \n"
    printf "${RESET}\n"
}

display_system_info() {
    local date_info="${BOLD}${BLUE}Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted):${RESET} ${GREEN}$(date +'%Y-%m-%d %H:%M:%S')${RESET}"
    local user_info="${BOLD}${BLUE}Current User's Login:${RESET} ${GREEN}$(whoami)${RESET}"
    
    printf "%s\n" "$date_info"
    printf "%s\n\n" "$user_info"
}

# Main program
logo
display_system_info

width=70

printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
printf "${CYAN}│${RESET}${BOLD}${WHITE} 📚 EXAM RANK 02 - PRACTICE LEVELS ${RESET}%$(($width - 34))s${CYAN}│${RESET}\n" ""
printf "${CYAN}├%s┤${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"

printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}   ${WHITE}Select the level you want to practice:${RESET}%$(($width - 39))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""

printf "${CYAN}│${RESET}   ${BOLD}${GREEN}1${RESET} ${WHITE}│${RESET} ${YELLOW}Level 0${RESET}${RESET} ${GREEN}[Beginner]${RESET}%$(($width - 27))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}      ${BLUE}↳ Introductory exercises for beginners${RESET}%$(($width - 46))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""

printf "${CYAN}│${RESET}   ${BOLD}${GREEN}2${RESET} ${WHITE}│${RESET} ${YELLOW}Level 1${RESET}${RESET} ${GREEN}[Intermediate]${RESET}%$(($width - 32))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}      ${BLUE}↳ Exercises for students with basic knowledge${RESET}%$(($width - 52))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""

printf "${CYAN}│${RESET}   ${BOLD}${GREEN}3${RESET} ${WHITE}│${RESET} ${YELLOW}Level 2${RESET}${RESET} ${GREEN}[Advanced]${RESET}%$(($width - 29))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}      ${BLUE}↳ Challenging exercises for experienced students${RESET}%$(($width - 55))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""

printf "${CYAN}│${RESET}   ${BOLD}${GREEN}4${RESET} ${WHITE}│${RESET} ${YELLOW}Level 3${RESET}${RESET} ${GREEN}[Expert]${RESET}%$(($width - 27))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}      ${BLUE}↳ Advanced exercises requiring deep understanding${RESET}%$(($width - 57))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""

printf "${CYAN}│${RESET}   ${BOLD}${MAGENTA}m${RESET} ${WHITE}│${RESET} ${YELLOW}Return to Main Menu${RESET}%$(($width - 25))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}   ${BOLD}${RED}e${RESET} ${WHITE}│${RESET} ${YELLOW}Exit Program${RESET}%$(($width - 18))s${CYAN}│${RESET}\n" ""
printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""

printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"

printf "\n${BOLD}${GREEN}▶ Enter your choice (1-4, m, e): ${RESET}"
read opt

case $opt in
    m|menu)
        bash menu.sh
        ;;
    1)
        clear
        echo "${GREEN}${BOLD}Level 0 is being prepared...${RESET}"
        display_animation
        clear
        bash sub_and_test.sh rank02 level0
        ;;
    2)  
        mkdir -p ../../rendu
        clear
        echo "${GREEN}${BOLD}Level 1 is being prepared...${RESET}"
        display_animation
        clear
        bash sub_and_test.sh rank02 level1
        ;;
    3) 
        mkdir -p ../../rendu
        clear
        echo "${GREEN}${BOLD}Level 2 is being prepared...${RESET}"
        display_animation
        clear
        bash sub_and_test.sh rank02 level2
        ;;
    4)
        mkdir -p ../../rendu
        clear
        echo "${GREEN}${BOLD}Level 3 is being prepared...${RESET}"
        display_animation
        clear
        bash sub_and_test.sh rank02 level3
        ;;
    e|exit)
        cd ../../../../
        rm -rf rendu
        clear
        exit 0
        ;;
    *)
        echo "${RED}${BOLD}Invalid choice. Please try again.${RESET}"
        sleep 1
        bash rank02.sh
        ;;
esac