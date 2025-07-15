#!/bin/bash

source colors.sh
source logging.sh
source backup_system.sh

# Initialize logging, configuration, and backup systems
init_logging
load_config
init_backup_system
system_health_check

# Create automatic backup if enabled and rendu exists
if [ "${AUTO_BACKUP:-1}" = "1" ] && [ -d "../../rendu" ] && [ "$(ls -A ../../rendu 2>/dev/null)" ]; then
    create_backup "auto_session_start"
fi

mkdir -p ../../rendu
clear

COLUMNS=$(tput cols)
LINES=$(tput lines)

# Center function
center() {
    local text="$1"
    local width="$2"
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s%${padding}s\n" "" "$text" ""
}

draw_box() {
    local width=$1
    local title="$2"
    local title_length=${#title}
    local padding=$(( (width - title_length - 4) / 2 ))
    
    printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
    printf "${CYAN}│${RESET}%${padding}s${BOLD}${WHITE} %s ${RESET}%${padding}s${CYAN}│${RESET}\n" "" "$title" ""
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
}

menu_item() {
    local number="$1"
    local text="$2"
    local width="$3"
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}%s.${RESET} %-$(($width - 7))s ${CYAN}│${RESET}\n" "$number" "$text"
}

menu_divider() {
    local width="$1"
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
}

menu_footer() {
    local width="$1"
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
}

logo() {
    printf "\n${BLUE}${BOLD}"
    printf "    ███╗   ███╗██████╗     ██████╗  ██████╗  ██████╗ ████████╗\n"
    printf "    ████╗ ████║██╔══██╗    ██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝\n"
    printf "    ██╔████╔██║██████╔╝    ██████╔╝██║   ██║██║   ██║   ██║   \n"
    printf "    ██║╚██╔╝██║██╔══██╗    ██╔══██╗██║   ██║██║   ██║   ██║   \n"
    printf "    ██║ ╚═╝ ██║██║  ██║    ██████╔╝╚██████╔╝╚██████╔╝   ██║   \n"
    printf "    ╚═╝     ╚═╝╚═╝  ╚═╝    ╚═════╝  ╚═════╝  ╚═════╝    ╚═╝   \n"
    printf "${RESET}\n"
}

display_system_info() {
    local date_info="${BOLD}${BLUE}Current Date and Time (UTC - YYYY-MM-DD HH:MM:SS formatted):${RESET} ${GREEN}$(date +'%Y-%m-%d %H:%M:%S')${RESET}"
    local user_info="${BOLD}${BLUE}Current User's Login:${RESET} ${GREEN}$(whoami)${RESET}"
    
    center "$date_info" "$COLUMNS"
    center "$user_info" "$COLUMNS"
    printf "\n"
}

wait_animation() {
    local message="${1:-Loading system...}"
    local duration="${2:-0.12}"
    
    local frames=(
      "[■□□□□□□□□□] 10% > Accessing system..."
      "[■■□□□□□□□□] 20% > Bypassing firewall..."
      "[■■■□□□□□□□] 30% > Cracking passwords..."
      "[■■■■□□□□□□] 40% > Injecting payload..."
      "[■■■■■□□□□□] 50% > Establishing connection..."
      "[■■■■■■□□□□] 60% > Scanning ports..."
      "[■■■■■■■□□□] 70% > Extracting data..."
      "[■■■■■■■■□□] 80% > Covering tracks..."
      "[■■■■■■■■■□] 90% > Deploying backdoor..."
      "[■■■■■■■■■■] 100% > Access granted!"
    )
    
    tput sc
    tput civis
    
    local width=60
    
    clear
    
    logo
    
    display_system_info
    
    draw_box $width "$message"
    
    local frame_line=$(($(tput lines) / 2 + 2))
    
    for frame in "${frames[@]}"; do
        tput cup $frame_line 5
        printf "${GREEN}${BOLD}%s${RESET}" "$frame"
        sleep $duration
    done
    
    sleep 0.5
    tput cup $((frame_line + 2)) 5
    printf "${GREEN}${BOLD}%s${RESET}" "PROGRAM LOADED SUCCESSFULLY"
    sleep 1
    
    tput cnorm
    tput rc
    
    clear
}

main() {
    local menu_width=60
    
    logo
    
    display_system_info
    
    draw_box $menu_width "EXAM PREPARATION SYSTEM"
    
    printf "${CYAN}│${RESET}%$(($menu_width - 2))s${CYAN}│${RESET}\n" ""
    menu_item "1" "Exam Rank 02" $menu_width
    menu_item "2" "Exam Rank 03         " $menu_width
    menu_item "3" "Exam Rank 04 ${YELLOW}[BETA]${RESET}         " $menu_width
    menu_item "4" "Commands" $menu_width
    menu_item "5" "Backup Management ${CYAN}[NEW]${RESET}     " $menu_width
    menu_item "6" "Update Shell ${YELLOW}[Latest Version Check]${RESET}     " $menu_width
    menu_item "7" "Open Rendu Folder" $menu_width
    printf "${CYAN}│${RESET}%$(($menu_width - 2))s${CYAN}│${RESET}\n" ""
    
    # Footer
    menu_footer $menu_width
    
    # Prompt
    printf "\n${BOLD}${GREEN}Enter your choice (1-7) or 'exit' to quit: ${RESET}"
    read opt

    case $opt in
        1)
            wait_animation "LOADING EXAM RANK 02" 0.15
            bash rank02.sh
            ;;
        2) 
            wait_animation "LOADING EXAM RANK 03" 0.15
            bash rank03.sh         
            ;;
        3)
            wait_animation "LOADING EXAM RANK 04" 0.15
            cd ../rank04
            bash rank04.sh
            ;;
        4)
            wait_animation "LOADING COMMAND HELP" 0.15
            bash help.sh
            ;;
        5)
            wait_animation "LOADING BACKUP SYSTEM" 0.15
            source backup_system.sh
            init_backup_system
            backup_manager
            ;;
        exit)
            wait_animation "EXITING SYSTEM" 0.15
            cd ../../../../
            rm -rf rendu
            clear
            exit 0
            ;;
        6)
            wait_animation "CHECKING FOR UPDATES" 0.15
            cd ../../
            bash update.sh
            ;;
        7)
            wait_animation "OPENING RENDU FOLDER" 0.15
            cd ../../rendu
            open .
            cd ../.resources/main
            bash menu.sh
            ;;
        *)
            echo "Invalid choice. Please enter a number from 1 to 7."
            sleep 1
            clear
            bash menu.sh
            ;;
    esac
}

# Run main function
main
