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
    
    center "$date_info" "$COLUMNS"
    center "$user_info" "$COLUMNS"
    printf "\n"
}

display_system_info_alt() {
    local date_str=$(date +'%Y-%m-%d')
    local time_str=$(date +'%H:%M:%S')
    local user_str=$(whoami)
    
    printf "\n${BLUE}${BOLD}╔══════════════════════ SYSTEM STATUS ══════════════════════╗${RESET}\n"
    printf "${BLUE}${BOLD}║${RESET} ${YELLOW}${date_str}${RESET} ${WHITE}•${RESET} ${GREEN}${time_str}${RESET} ${WHITE}•${RESET} ${CYAN}${user_str}${RESET}"
    
    local content_length=$((${#date_str} + ${#time_str} + ${#user_str} + 4)) # +4 for bullets and spaces
    local padding=$((64 - content_length))
    
    printf "%${padding}s${BLUE}${BOLD}║${RESET}\n" ""
    printf "${BLUE}${BOLD}╚══════════════════════════════════════════════════════════╝${RESET}\n\n"
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
    
    local width=70
    
    clear
    
    logo
    
    display_system_info_alt
    
    printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
    printf "${CYAN}│${RESET}${BOLD}${WHITE} ⚡ %s ⚡${RESET}%$(($width - ${#message} - 7))s${CYAN}│${RESET}\n" "$message"
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
    
    local frame_line=$(($(tput lines) / 2))
    
    for frame in "${frames[@]}"; do
        tput cup $frame_line 5
        printf "${GREEN}${BOLD}%s${RESET}" "$frame"
        sleep $duration
    done
    
    sleep 0.5
    tput cup $((frame_line + 2)) $(( (width - 30) / 2 ))
    printf "${GREEN}${BOLD}✓ PROGRAM LOADED SUCCESSFULLY ✓${RESET}"
    sleep 1
    
    tput cnorm
    tput rc
    
    clear
}

show_subject() {
    local exercise_path="$1"
    local exercise_name="$2"
    
    cd "../../.resources/rank03/$exercise_path/"
    
    clear
    logo
    
    printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 70))"
    printf "${CYAN}│${RESET}${BOLD}${WHITE} 📄 $exercise_name SUBJECT ${RESET}%$((70 - ${#exercise_name} - 14))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 70))"
    
    printf "${CYAN}│${RESET} ${WHITE}                                                                  ${CYAN}│${RESET}\n"
    
    while IFS= read -r line; do
        printf "${CYAN}│${RESET} ${YELLOW}%-68s${RESET} ${CYAN}│${RESET}\n" "$line"
    done < subject.txt
    
    printf "${CYAN}│${RESET} ${WHITE}                                                                  ${CYAN}│${RESET}\n"
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 70))"
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}OPTIONS:${RESET}%57s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%70s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}1.${RESET} ${WHITE}Run Tests${RESET}%56s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}b.${RESET} ${WHITE}Back to Exercise Menu${RESET}%45s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%70s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 70))"
    
    printf "\n${BOLD}${GREEN}Enter your choice: ${RESET}"
    read choice
    
    case $choice in
        1)
            clear
            echo "${YELLOW}${BOLD}Running tests for $exercise_name...${RESET}"
            printf "${YELLOW}${BOLD}╔═══════════════════════ TEST RESULTS ═══════════════════════╗${RESET}\n"
            bash tester.sh
            printf "${YELLOW}${BOLD}╚════════════════════════════════════════════════════════════╝${RESET}\n"
            echo ""
            echo "${BOLD}${GREEN}Press Enter to return to the subject${RESET}"
            read
            
            show_subject "$exercise_path" "$exercise_name"
            ;;
        2)
            local source_file=""
            if [ -f "${exercise_path}.c" ]; then
                source_file="${exercise_path}.c"
            else
                source_file=$(ls *.c | head -1)
            fi
            
            ${EDITOR:-vim} "$source_file"
            
            show_subject "$exercise_path" "$exercise_name"
            ;;
        b|B)
            cd "../../../.resources/main/"
            return
            ;;
        *)
            echo "${RED}${BOLD}Invalid choice. Please enter 1, 2, or 'b'.${RESET}"
            sleep 1
            
            # Redisplay subject
            show_subject "$exercise_path" "$exercise_name"
            ;;
    esac
}

display_exercises() {
    local width=70
    
    while true; do
        clear
        logo
        
        display_system_info_alt
        
        printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
        printf "${CYAN}│${RESET}${BOLD}${WHITE} ⚙️  EXAM RANK 03 - EXERCISES ${RESET}%$(($width - 31))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $width))"
        
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${YELLOW}Select an exercise to practice:${RESET}%$(($width - 33))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        
        printf "${CYAN}│${RESET}   ${BOLD}${GREEN}1.${RESET} ${WHITE}ft_printf${RESET} ${YELLOW}[Advanced]${RESET}%$(($width - 29))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}      ${BLUE}↳ Implement your own version of the printf function${RESET}%$(($width - 59))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${BOLD}${GREEN}2.${RESET} ${WHITE}get_next_line${RESET} ${YELLOW}[Advanced]${RESET}%$(($width - 33))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}      ${BLUE}↳ Create a function that reads a line from a file descriptor${RESET}%$(($width - 70))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${BOLD}${MAGENTA}b.${RESET} ${WHITE}Back to Main Menu${RESET}%$(($width - 23))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        
        printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
        
        printf "\n${BOLD}${GREEN}Enter your choice (1-2) or 'b' to go back: ${RESET}"
        read choice
        
        case $choice in
            1)
                wait_animation "LOADING FT_PRINTF EXERCISE" 0.12
                show_subject "ft_printf" "FT_PRINTF"
                ;;
            2)
                wait_animation "LOADING GET_NEXT_LINE EXERCISE" 0.12
                show_subject "get_next_line" "GET_NEXT_LINE"
                ;;
            b|B)
                wait_animation "RETURNING TO MAIN MENU" 0.08
                cd ../.resources/main/
                bash menu.sh
                return
                ;;
            *)
                echo -e "${RED}${BOLD}Invalid choice. Please enter 1, 2, or 'b'.${RESET}"
                sleep 1
                ;;
        esac
    done
}

main() {
    local width=70
    
    while true; do
        clear
        logo
        display_system_info_alt
        
        printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
        printf "${CYAN}│${RESET}${BOLD}${WHITE} 🚀 EXAM RANK 03 - MAIN MENU ${RESET}%$(($width - 30))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $width))"
        
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${WHITE}Welcome to the Exam Rank 03 Training System${RESET}%$(($width - 49))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${BOLD}${GREEN}1.${RESET} ${WHITE}Practice Exercises${RESET}%$(($width - 25))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}      ${BLUE}↳ Access ft_printf and get_next_line exercises${RESET}%$(($width - 53))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${BOLD}${GREEN}3.${RESET} ${WHITE}Check Your Progress${RESET}%$(($width - 26))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}      ${BLUE}↳ View your completion status for all exercises${RESET}%$(($width - 56))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${BOLD}${MAGENTA}b.${RESET} ${WHITE}Back to Main Menu${RESET}%$(($width - 23))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        
    
        printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
        
        printf "\n${BOLD}${GREEN}Enter your choice (1, 3) or 'b' to go back: ${RESET}"
        read choice
        
        case $choice in
            1)
                wait_animation "LOADING EXERCISES MENU" 0.12
                display_exercises
                ;;
            3)
                wait_animation "CHECKING PROGRESS STATUS" 0.12
                
                clear
                logo
                display_system_info_alt
                
                printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
                printf "${CYAN}│${RESET}${BOLD}${WHITE} 📊 YOUR PROGRESS ${RESET}%$(($width - 20))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $width))"
                
                printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}   ${BOLD}${GREEN}Completed Exercises:${RESET}%$(($width - 25))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}   [${RED}✗${RESET}] ${WHITE}ft_printf${RESET}%$(($width - 16))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}   [${RED}✗${RESET}] ${WHITE}get_next_line${RESET}%$(($width - 20))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}   ${BOLD}${GREEN}Overall Progress: ${RESET}${WHITE}[${RED}▯▯▯▯▯▯▯▯▯▯${WHITE}] ${RED}0%%${RESET}%$(($width - 37))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}   ${YELLOW}Complete exercises to increase your progress.${RESET}%$(($width - 49))s${CYAN}│${RESET}\n" ""
                printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
                
                printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $width))"
                
                printf "\n${BOLD}${GREEN}Press Enter to continue${RESET}"
                read
                
                clear
                ;;
            b|B)
                wait_animation "RETURNING TO MAIN MENU" 0.08
                cd ../.resources/main/
                bash menu.sh
                return
                ;;
            *)
                echo -e "${RED}${BOLD}Invalid choice. Please enter 1, 3, or 'b'.${RESET}"
                sleep 1
                ;;
        esac
    done
}

main