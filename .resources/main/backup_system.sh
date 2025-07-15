#!/bin/bash

# Backup and Recovery System for GradeMe-1337
# Provides automatic backup of student work and recovery capabilities

source colors.sh
source logging.sh

BACKUP_DIR="../../backups"
RENDU_DIR="../../rendu"

# Initialize backup system
init_backup_system() {
    mkdir -p "$BACKUP_DIR"
    log_message "INFO" "Backup system initialized"
}

# Create automatic backup
create_backup() {
    local backup_type="${1:-manual}"
    local timestamp=$(date +'%Y%m%d_%H%M%S')
    local backup_name="backup_${backup_type}_${timestamp}"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    if [ ! -d "$RENDU_DIR" ] || [ -z "$(ls -A "$RENDU_DIR" 2>/dev/null)" ]; then
        log_message "INFO" "No work to backup in rendu directory"
        return 0
    fi
    
    echo "${CYAN}${BOLD}Creating backup: $backup_name${RESET}"
    
    # Create backup with compression
    mkdir -p "$backup_path"
    cp -r "$RENDU_DIR"/* "$backup_path/" 2>/dev/null
    
    # Create metadata
    cat > "$backup_path/backup_info.txt" << EOF
Backup Information
==================
Type: $backup_type
Created: $(date +'%Y-%m-%d %H:%M:%S')
User: $(whoami)
Source: $RENDU_DIR
Files: $(find "$RENDU_DIR" -type f | wc -l)
Size: $(du -sh "$RENDU_DIR" | cut -f1)
EOF
    
    # Compress backup
    cd "$BACKUP_DIR"
    tar -czf "${backup_name}.tar.gz" "$backup_name" 2>/dev/null
    rm -rf "$backup_name"
    cd - > /dev/null
    
    local backup_size=$(du -sh "$BACKUP_DIR/${backup_name}.tar.gz" | cut -f1)
    echo "${GREEN}✓ Backup created: ${backup_name}.tar.gz (${backup_size})${RESET}"
    log_message "INFO" "Backup created: ${backup_name}.tar.gz (${backup_size})"
    
    # Clean old backups (keep last 10)
    cleanup_old_backups
}

# List available backups
list_backups() {
    echo "${CYAN}${BOLD}Available Backups:${RESET}"
    echo "=================="
    
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
        echo "${YELLOW}No backups found${RESET}"
        return 0
    fi
    
    local count=1
    for backup in "$BACKUP_DIR"/*.tar.gz; do
        if [ -f "$backup" ]; then
            local filename=$(basename "$backup")
            local size=$(du -sh "$backup" | cut -f1)
            local date=$(stat -c %y "$backup" | cut -d' ' -f1,2 | cut -d'.' -f1)
            
            printf "${GREEN}%2d.${RESET} ${WHITE}%-40s${RESET} ${BLUE}%s${RESET} ${YELLOW}(%s)${RESET}\n" \
                   "$count" "$filename" "$date" "$size"
            count=$((count + 1))
        fi
    done
}

# Restore from backup
restore_backup() {
    local backup_selection="$1"
    
    list_backups
    
    if [ -z "$backup_selection" ]; then
        echo ""
        read -p "${BOLD}${GREEN}Enter backup number to restore (or 'q' to quit): ${RESET}" backup_selection
    fi
    
    if [ "$backup_selection" = "q" ] || [ "$backup_selection" = "quit" ]; then
        return 0
    fi
    
    # Get backup file by number
    local backup_files=("$BACKUP_DIR"/*.tar.gz)
    local selected_index=$((backup_selection - 1))
    
    if [ $selected_index -lt 0 ] || [ $selected_index -ge ${#backup_files[@]} ]; then
        echo "${RED}${BOLD}Invalid backup selection${RESET}"
        return 1
    fi
    
    local backup_file="${backup_files[$selected_index]}"
    local backup_name=$(basename "$backup_file" .tar.gz)
    
    echo "${YELLOW}${BOLD}Warning: This will replace all current work in the rendu directory!${RESET}"
    read -p "Are you sure you want to restore backup '$backup_name'? (y/N): " confirm
    
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "${CYAN}Restore cancelled${RESET}"
        return 0
    fi
    
    # Create backup of current work before restore
    if [ -d "$RENDU_DIR" ] && [ "$(ls -A "$RENDU_DIR" 2>/dev/null)" ]; then
        create_backup "pre_restore"
    fi
    
    # Extract backup
    echo "${CYAN}${BOLD}Restoring backup: $backup_name${RESET}"
    
    rm -rf "$RENDU_DIR"
    mkdir -p "$RENDU_DIR"
    
    cd "$BACKUP_DIR"
    tar -xzf "$backup_file" 2>/dev/null
    cp -r "$backup_name"/* "$RENDU_DIR/" 2>/dev/null
    rm -rf "$backup_name"
    cd - > /dev/null
    
    echo "${GREEN}${BOLD}✓ Backup restored successfully${RESET}"
    log_message "INFO" "Backup restored: $backup_name"
    
    # Show restored contents
    echo ""
    echo "${CYAN}Restored files:${RESET}"
    find "$RENDU_DIR" -type f | head -10 | while read -r file; do
        echo "  ${BLUE}$(basename "$file")${RESET}"
    done
    
    local file_count=$(find "$RENDU_DIR" -type f | wc -l)
    if [ $file_count -gt 10 ]; then
        echo "  ${YELLOW}... and $((file_count - 10)) more files${RESET}"
    fi
}

# Cleanup old backups (keep last N)
cleanup_old_backups() {
    local keep_count=${1:-10}
    
    if [ ! -d "$BACKUP_DIR" ]; then
        return 0
    fi
    
    local backup_count=$(ls -1 "$BACKUP_DIR"/*.tar.gz 2>/dev/null | wc -l)
    
    if [ $backup_count -gt $keep_count ]; then
        local delete_count=$((backup_count - keep_count))
        echo "${YELLOW}Cleaning up $delete_count old backups (keeping latest $keep_count)${RESET}"
        
        ls -t "$BACKUP_DIR"/*.tar.gz | tail -n +$((keep_count + 1)) | while read -r old_backup; do
            rm -f "$old_backup"
            echo "  ${RED}Deleted: $(basename "$old_backup")${RESET}"
        done
        
        log_message "INFO" "Cleaned up $delete_count old backups"
    fi
}

# Interactive backup management
backup_manager() {
    local width=70
    
    while true; do
        clear
        echo "${BLUE}${BOLD}"
        echo "    ██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗ "
        echo "    ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗"
        echo "    ██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝"
        echo "    ██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝ "
        echo "    ██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║     "
        echo "    ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     "
        echo "${RESET}"
        
        printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
        printf "${CYAN}│${RESET}${BOLD}${WHITE}%*s${RESET}${CYAN}│${RESET}\n" $(((${#1} + $width - 2)/2)) "BACKUP MANAGEMENT SYSTEM"
        printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
        
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}1.${RESET} Create Manual Backup%$(($width - 26))s ${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}2.${RESET} List Available Backups%$(($width - 28))s ${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}3.${RESET} Restore from Backup%$(($width - 25))s ${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}4.${RESET} Cleanup Old Backups%$(($width - 26))s ${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET} ${BOLD}${MAGENTA}b.${RESET} Back to Main Menu%$(($width - 23))s ${CYAN}│${RESET}\n" ""
        
        printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
        
        printf "\n${BOLD}${GREEN}Enter your choice: ${RESET}"
        read choice
        
        case $choice in
            1)
                create_backup "manual"
                read -p "Press Enter to continue..."
                ;;
            2)
                list_backups
                read -p "Press Enter to continue..."
                ;;
            3)
                restore_backup
                read -p "Press Enter to continue..."
                ;;
            4)
                echo "Enter number of backups to keep (default: 10): "
                read keep_count
                cleanup_old_backups "${keep_count:-10}"
                read -p "Press Enter to continue..."
                ;;
            b|B)
                return 0
                ;;
            *)
                echo "${RED}Invalid choice${RESET}"
                sleep 1
                ;;
        esac
    done
}

# Export functions
export -f init_backup_system create_backup list_backups restore_backup cleanup_old_backups backup_manager