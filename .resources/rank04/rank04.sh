#!/bin/bash

source colors.sh
clear

COLUMNS=$(tput cols)
LINES=$(tput lines)

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

menu_footer() {
    local width="$1"
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
}

logo() {
    printf "\n${MAGENTA}${BOLD}"
    printf "    ███████╗██╗  ██╗ █████╗ ███╗   ███╗    ██████╗  █████╗ ███╗   ██╗██╗  ██╗    ██╗  ██╗\n"
    printf "    ██╔════╝╚██╗██╔╝██╔══██╗████╗ ████║    ██╔══██╗██╔══██╗████╗  ██║██║ ██╔╝    ██║  ██║\n"
    printf "    █████╗   ╚███╔╝ ███████║██╔████╔██║    ██████╔╝███████║██╔██╗ ██║█████╔╝     ███████║\n"
    printf "    ██╔══╝   ██╔██╗ ██╔══██║██║╚██╔╝██║    ██╔══██╗██╔══██║██║╚██╗██║██╔═██╗     ╚════██║\n"
    printf "    ███████╗██╔╝ ██╗██║  ██║██║ ╚═╝ ██║    ██║  ██║██║  ██║██║ ╚████║██║  ██╗          ██║\n"
    printf "    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝  ╚═╝          ╚═╝\n"
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
      "[■□□□□□□□□□] 10% > Initializing Rank 04..."
      "[■■□□□□□□□□] 20% > Loading exercise database..."
      "[■■■□□□□□□□] 30% > Setting up environment..."
      "[■■■■□□□□□□] 40% > Preparing advanced tests..."
      "[■■■■■□□□□□] 50% > Configuring debugger..."
      "[■■■■■■□□□□] 60% > Loading reference solutions..."
      "[■■■■■■■□□□] 70% > Setting up monitoring..."
      "[■■■■■■■■□□] 80% > Initializing progress tracker..."
      "[■■■■■■■■■□] 90% > Finalizing setup..."
      "[■■■■■■■■■■] 100% > Ready for Rank 04!"
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
    printf "${GREEN}${BOLD}%s${RESET}" "RANK 04 SYSTEM READY"
    sleep 1
    
    tput cnorm
    tput rc
    
    clear
}

main() {
    local menu_width=70
    
    logo
    
    display_system_info
    
    draw_box $menu_width "EXAM RANK 04 - ADVANCED PRACTICE (BETA)"
    
    printf "${CYAN}│${RESET}%$(($menu_width - 2))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${YELLOW}${BOLD}🚧 COMING SOON - ADVANCED FEATURES 🚧${RESET}%$(($menu_width - 39))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($menu_width - 2))s${CYAN}│${RESET}\n" ""
    
    menu_item "1" "Mini-project Practice ${YELLOW}[Under Development]${RESET}" $menu_width
    menu_item "2" "Advanced Algorithm Challenges ${YELLOW}[Coming Soon]${RESET}" $menu_width  
    menu_item "3" "Code Review & Optimization ${YELLOW}[Planning]${RESET}" $menu_width
    menu_item "4" "System Design Practice ${YELLOW}[Concept]${RESET}" $menu_width
    printf "${CYAN}│${RESET}%$(($menu_width - 2))s${CYAN}│${RESET}\n" ""
    menu_item "b" "Back to Main Menu" $menu_width
    printf "${CYAN}│${RESET}%$(($menu_width - 2))s${CYAN}│${RESET}\n" ""
    
    # Footer
    menu_footer $menu_width
    
    printf "\n${BOLD}${BLUE}📝 Note: Rank 04 is currently in development. Features will be added progressively.${RESET}\n"
    printf "${BOLD}${GREEN}Enter your choice (1-4, b) or 'exit' to quit: ${RESET}"
    read opt

    case $opt in
        1)
            wait_animation "PREPARING MINI-PROJECT ENVIRONMENT" 0.15
            echo "${YELLOW}${BOLD}Mini-project practice coming soon!${RESET}"
            echo "${CYAN}This will include:${RESET}"
            echo "• Complete C projects with multiple files"
            echo "• Makefile creation and management"
            echo "• Library development practice"
            echo "• Code organization and structure"
            sleep 3
            main
            ;;
        2) 
            wait_animation "LOADING ALGORITHM CHALLENGES" 0.15
            echo "${YELLOW}${BOLD}Advanced algorithms coming soon!${RESET}"
            echo "${CYAN}This will include:${RESET}"
            echo "• Complex data structure implementations"
            echo "• Advanced sorting and searching algorithms"
            echo "• Graph algorithms and tree traversals"
            echo "• Dynamic programming challenges"
            sleep 3
            main
            ;;
        3)
            wait_animation "SETTING UP CODE REVIEW SYSTEM" 0.15
            echo "${YELLOW}${BOLD}Code review practice coming soon!${RESET}"
            echo "${CYAN}This will include:${RESET}"
            echo "• Performance optimization techniques"
            echo "• Code quality assessment tools"
            echo "• Best practices enforcement"
            echo "• Memory leak detection"
            sleep 3
            main
            ;;
        4)
            wait_animation "INITIALIZING SYSTEM DESIGN MODULE" 0.15
            echo "${YELLOW}${BOLD}System design practice coming soon!${RESET}"
            echo "${CYAN}This will include:${RESET}"
            echo "• Architecture design principles"
            echo "• Scalability considerations"
            echo "• Design pattern implementations"
            echo "• System integration practice"
            sleep 3
            main
            ;;
        b|back)
            wait_animation "RETURNING TO MAIN MENU" 0.15
            cd ../main
            bash menu.sh
            ;;
        exit)
            wait_animation "EXITING SYSTEM" 0.15
            cd ../../../../
            rm -rf rendu
            clear
            exit 0
            ;;
        *)
            echo "${RED}Invalid choice. Please enter a number from 1 to 4, 'b', or 'exit'.${RESET}"
            sleep 1
            clear
            main
            ;;
    esac
}

# Run main function
main