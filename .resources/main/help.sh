#!/bin/bash

source colors.sh
source logging.sh

clear

log_message "INFO" "Help system accessed"

COLUMNS=$(tput cols)
LINES=$(tput lines)

# Center function
center() {
    local text="$1"
    local width="$2"
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%${padding}s%s%${padding}s\n" "" "$text" ""
}

logo() {
    printf "\n${BLUE}${BOLD}"
    printf "    ██╗  ██╗███████╗██╗     ██████╗     ███████╗██╗   ██╗███████╗████████╗███████╗███╗   ███╗\n"
    printf "    ██║  ██║██╔════╝██║     ██╔══██╗    ██╔════╝╚██╗ ██╔╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║\n"
    printf "    ███████║█████╗  ██║     ██████╔╝    ███████╗ ╚████╔╝ ███████╗   ██║   █████╗  ██╔████╔██║\n"
    printf "    ██╔══██║██╔══╝  ██║     ██╔═══╝     ╚════██║  ╚██╔╝  ╚════██║   ██║   ██╔══╝  ██║╚██╔╝██║\n"
    printf "    ██║  ██║███████╗███████╗██║         ███████║   ██║   ███████║   ██║   ███████╗██║ ╚═╝ ██║\n"
    printf "    ╚═╝  ╚═╝╚══════╝╚══════╝╚═╝         ╚══════╝   ╚═╝   ╚══════╝   ╚═╝   ╚══════╝╚═╝     ╚═╝\n"
    printf "${RESET}\n"
}

show_commands() {
    local width=80
    
    printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
    printf "${CYAN}│${RESET}${BOLD}${WHITE}%*s${RESET}${CYAN}│${RESET}\n" $(((${#1} + $width - 2)/2)) "📋 COMMAND REFERENCE"
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}During Exercise Practice:${RESET}%$(($width - 27))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}test${RESET}  - Run tests for current exercise%$(($width - 40))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}next${RESET}  - Move to next exercise%$(($width - 34))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}menu${RESET}  - Return to main menu%$(($width - 33))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}exit${RESET}  - Exit the program%$(($width - 29))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}Menu Navigation:${RESET}%$(($width - 19))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}1-6${RESET}   - Select menu option by number%$(($width - 40))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}b${RESET}     - Go back to previous menu%$(($width - 36))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}exit${RESET}  - Exit program%$(($width - 25))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
}

show_tips() {
    local width=80
    
    printf "\n${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
    printf "${CYAN}│${RESET}${BOLD}${WHITE}%*s${RESET}${CYAN}│${RESET}\n" $(((${#1} + $width - 2)/2)) "💡 HELPFUL TIPS"
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}File Organization:${RESET}%$(($width - 21))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Your solutions go in the ${YELLOW}rendu${RESET} folder%$(($width - 46))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Create subdirectories for each exercise%$(($width - 47))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Example: ${YELLOW}rendu/ft_printf/ft_printf.c${RESET}%$(($width - 44))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}Testing Best Practices:${RESET}%$(($width - 26))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Test early and often%$(($width - 27))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Read error messages carefully%$(($width - 35))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Check compilation warnings%$(($width - 33))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Use proper function prototypes%$(($width - 37))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}Performance Tips:${RESET}%$(($width - 20))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Logs are stored in ${YELLOW}logs/${RESET} directory%$(($width - 41))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Check ${YELLOW}logs/session.log${RESET} for detailed information%$(($width - 52))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   • Use ${YELLOW}trace/${RESET} directory for debugging%$(($width - 39))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
}

show_shortcuts() {
    local width=80
    
    printf "\n${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
    printf "${CYAN}│${RESET}${BOLD}${WHITE}%*s${RESET}${CYAN}│${RESET}\n" $(((${#1} + $width - 2)/2)) "⚡ KEYBOARD SHORTCUTS"
    printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}Quick Actions:${RESET}%$(($width - 17))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}Ctrl+C${RESET} - Interrupt current operation%$(($width - 39))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}Ctrl+Z${RESET} - Suspend current process%$(($width - 37))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}Ctrl+L${RESET} - Clear screen%$(($width - 26))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}│${RESET} ${BOLD}${GREEN}Text Navigation:${RESET}%$(($width - 19))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}Arrow Keys${RESET} - Navigate through history%$(($width - 40))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}Tab${RESET} - Auto-complete commands%$(($width - 31))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}   ${BLUE}Enter${RESET} - Execute command%$(($width - 27))s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
    
    printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
}

main() {
    logo
    
    printf "${BOLD}${BLUE}Welcome to the GradeMe-1337 Help System!${RESET}\n\n"
    
    show_commands
    show_tips
    show_shortcuts
    
    printf "\n${BOLD}${GREEN}📚 Additional Resources:${RESET}\n"
    printf "• Check ${YELLOW}logs/session.log${RESET} for detailed operation logs\n"
    printf "• View ${YELLOW}logs/test_results.csv${RESET} for testing history\n"
    printf "• Use ${YELLOW}trace/${RESET} directory for debugging compilation issues\n"
    printf "• Configuration can be modified in ${YELLOW}config/settings.conf${RESET}\n\n"
    
    printf "${CYAN}╭════════════════════════════════════════════════════════════════════════════╮${RESET}\n"
    printf "${CYAN}│${RESET} ${BOLD}${WHITE}Press Enter to return to the main menu${RESET}%35s ${CYAN}│${RESET}\n" ""
    printf "${CYAN}╰════════════════════════════════════════════════════════════════════════════╯${RESET}\n"
    
    read -r
    log_message "INFO" "Help system closed"
    bash menu.sh
}

main
