#!/bin/bash

# Enhanced logging and progress tracking system for GradeMe-1337
# This provides detailed logging capabilities and performance monitoring

LOG_DIR="../../logs"
TRACE_DIR="../../trace"
CONFIG_DIR="../../config"

# Initialize logging system
init_logging() {
    mkdir -p "$LOG_DIR" "$TRACE_DIR" "$CONFIG_DIR"
    
    # Create session log with header
    cat > "$LOG_DIR/session.log" << EOF
# GradeMe-1337 Session Log
# Started: $(date +'%Y-%m-%d %H:%M:%S')
# User: $(whoami)
# PWD: $(pwd)
=====================================

EOF

    # Performance tracking
    echo "$(date +'%Y-%m-%d %H:%M:%S'),system_start,0" > "$LOG_DIR/performance.csv"
    
    # Error tracking
    touch "$LOG_DIR/errors.log"
    
    # Test results tracking
    echo "timestamp,exercise,level,result,duration" > "$LOG_DIR/test_results.csv"
}

# Log function with different levels
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp] [$level] $message" >> "$LOG_DIR/session.log"
    
    # Also log errors separately
    if [ "$level" = "ERROR" ] || [ "$level" = "CRITICAL" ]; then
        echo "[$timestamp] [$level] $message" >> "$LOG_DIR/errors.log"
    fi
    
    # Show in console for important messages
    if [ "$level" = "ERROR" ] || [ "$level" = "CRITICAL" ]; then
        echo "${RED}[$level] $message${RESET}" >&2
    elif [ "$level" = "WARNING" ]; then
        echo "${YELLOW}[$level] $message${RESET}" >&2
    elif [ "$level" = "INFO" ] && [ "${VERBOSE:-0}" = "1" ]; then
        echo "${CYAN}[$level] $message${RESET}" >&2
    fi
}

# Performance tracking
track_performance() {
    local operation="$1"
    local duration="$2"
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    echo "$timestamp,$operation,$duration" >> "$LOG_DIR/performance.csv"
}

# Test result tracking
log_test_result() {
    local exercise="$1"
    local level="$2"
    local result="$3"
    local duration="$4"
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    echo "$timestamp,$exercise,$level,$result,$duration" >> "$LOG_DIR/test_results.csv"
    log_message "INFO" "Test completed: $exercise ($level) - $result in ${duration}s"
}

# Progress tracking
show_progress() {
    local current="$1"
    local total="$2"
    local operation="$3"
    
    local percentage=$((current * 100 / total))
    local filled=$((percentage / 5))
    local empty=$((20 - filled))
    
    local bar=""
    for ((i=0; i<filled; i++)); do bar+="■"; done
    for ((i=0; i<empty; i++)); do bar+="□"; done
    
    printf "\r${CYAN}${BOLD}[%s] %d%% - %s${RESET}" "$bar" "$percentage" "$operation"
    
    if [ "$current" -eq "$total" ]; then
        echo ""
    fi
}

# Enhanced error handling
handle_error() {
    local exit_code="$1"
    local error_message="$2"
    local context="$3"
    
    log_message "ERROR" "Exit code $exit_code: $error_message (Context: $context)"
    
    # Generate error report
    cat > "$TRACE_DIR/last_error.txt" << EOF
Error Report
============
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
Exit Code: $exit_code
Message: $error_message
Context: $context
User: $(whoami)
PWD: $(pwd)
System: $(uname -a)

Recent Log Entries:
$(tail -10 "$LOG_DIR/session.log")
EOF
    
    return $exit_code
}

# System health check
system_health_check() {
    log_message "INFO" "Performing system health check"
    
    local issues=0
    
    # Check disk space
    local disk_usage=$(df . | tail -1 | awk '{print $5}' | sed 's/%//')
    if [ "$disk_usage" -gt 90 ]; then
        log_message "WARNING" "Disk usage high: ${disk_usage}%"
        issues=$((issues + 1))
    fi
    
    # Check required directories
    for dir in "$LOG_DIR" "$TRACE_DIR" "$CONFIG_DIR" "../../rendu"; do
        if [ ! -d "$dir" ]; then
            log_message "WARNING" "Missing directory: $dir"
            mkdir -p "$dir"
            issues=$((issues + 1))
        fi
    done
    
    # Check for gcc
    if ! command -v gcc &> /dev/null; then
        log_message "CRITICAL" "GCC compiler not found"
        issues=$((issues + 1))
    fi
    
    if [ $issues -eq 0 ]; then
        log_message "INFO" "System health check passed"
        return 0
    else
        log_message "WARNING" "System health check found $issues issues"
        return 1
    fi
}

# Configuration management
load_config() {
    local config_file="$CONFIG_DIR/settings.conf"
    
    if [ ! -f "$config_file" ]; then
        # Create default configuration
        cat > "$config_file" << EOF
# GradeMe-1337 Configuration
VERBOSE=0
PARALLEL_TESTS=0
CLEANUP_TEMP=1
SHOW_PROGRESS=1
LOG_LEVEL=INFO
COMPILE_TIMEOUT=30
TEST_TIMEOUT=10
AUTO_BACKUP=1
PERFORMANCE_TRACKING=1
EOF
        log_message "INFO" "Created default configuration"
    fi
    
    # Load configuration
    source "$config_file"
    log_message "INFO" "Configuration loaded"
}

# Cleanup function
cleanup_session() {
    log_message "INFO" "Cleaning up session"
    
    if [ "${CLEANUP_TEMP:-1}" = "1" ]; then
        find "$TRACE_DIR" -name "*.tmp" -type f -delete 2>/dev/null
        find "$TRACE_DIR" -name "out*" -type f -delete 2>/dev/null
    fi
    
    # Archive old logs if they get too large
    if [ -f "$LOG_DIR/session.log" ] && [ $(wc -l < "$LOG_DIR/session.log") -gt 1000 ]; then
        mv "$LOG_DIR/session.log" "$LOG_DIR/session_$(date +%Y%m%d_%H%M%S).log"
        log_message "INFO" "Archived large session log"
    fi
}

# Export functions for use in other scripts
export -f log_message track_performance log_test_result show_progress handle_error