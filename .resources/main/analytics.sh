#!/bin/bash

# Performance Analytics and Monitoring System for GradeMe-1337
# Provides detailed performance metrics and analysis

source colors.sh
source logging.sh

ANALYTICS_DIR="../../analytics"
REPORTS_DIR="../../reports"

# Initialize analytics system
init_analytics() {
    mkdir -p "$ANALYTICS_DIR" "$REPORTS_DIR"
    
    # Create performance metrics file
    if [ ! -f "$ANALYTICS_DIR/metrics.csv" ]; then
        echo "timestamp,category,operation,duration,result,memory_kb,cpu_percent" > "$ANALYTICS_DIR/metrics.csv"
    fi
    
    log_message "INFO" "Analytics system initialized"
}

# Record performance metric
record_metric() {
    local category="$1"
    local operation="$2"
    local duration="$3"
    local result="$4"
    local memory_kb="${5:-0}"
    local cpu_percent="${6:-0}"
    local timestamp=$(date +'%Y-%m-%d %H:%M:%S')
    
    echo "$timestamp,$category,$operation,$duration,$result,$memory_kb,$cpu_percent" >> "$ANALYTICS_DIR/metrics.csv"
}

# Monitor system resources during operation
monitor_resources() {
    local operation="$1"
    local pid="$2"
    local interval="${3:-1}"
    
    local max_memory=0
    local total_cpu=0
    local samples=0
    
    while kill -0 "$pid" 2>/dev/null; do
        if command -v ps &> /dev/null; then
            local memory_kb=$(ps -o rss= -p "$pid" 2>/dev/null || echo 0)
            local cpu_percent=$(ps -o %cpu= -p "$pid" 2>/dev/null || echo 0)
            
            if [ "$memory_kb" -gt "$max_memory" ]; then
                max_memory=$memory_kb
            fi
            
            total_cpu=$(echo "$total_cpu + $cpu_percent" | bc 2>/dev/null || echo $total_cpu)
            samples=$((samples + 1))
        fi
        
        sleep "$interval"
    done
    
    local avg_cpu=0
    if [ $samples -gt 0 ] && command -v bc &> /dev/null; then
        avg_cpu=$(echo "scale=2; $total_cpu / $samples" | bc 2>/dev/null || echo 0)
    fi
    
    echo "$max_memory,$avg_cpu"
}

# Generate performance report
generate_performance_report() {
    local period="${1:-week}"
    local report_file="$REPORTS_DIR/performance_report_$(date +%Y%m%d_%H%M%S).txt"
    
    echo "${CYAN}${BOLD}Generating performance report for last $period...${RESET}"
    
    local date_filter=""
    case $period in
        "day")
            date_filter=$(date -d '1 day ago' +'%Y-%m-%d')
            ;;
        "week")
            date_filter=$(date -d '1 week ago' +'%Y-%m-%d')
            ;;
        "month")
            date_filter=$(date -d '1 month ago' +'%Y-%m-%d')
            ;;
    esac
    
    cat > "$report_file" << EOF
GradeMe-1337 Performance Report
===============================
Generated: $(date +'%Y-%m-%d %H:%M:%S')
Period: Last $period (since $date_filter)
User: $(whoami)

EOF
    
    if [ -f "$ANALYTICS_DIR/metrics.csv" ]; then
        # Test execution statistics
        echo "Test Execution Statistics:" >> "$report_file"
        echo "-------------------------" >> "$report_file"
        
        local total_tests=$(awk -F',' '$2=="test" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        local passed_tests=$(awk -F',' '$2=="test" && $4=="PASS" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        local failed_tests=$(awk -F',' '$2=="test" && $4=="FAIL" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        
        echo "Total Tests: $total_tests" >> "$report_file"
        echo "Passed: $passed_tests" >> "$report_file"
        echo "Failed: $failed_tests" >> "$report_file"
        
        if [ $total_tests -gt 0 ]; then
            local success_rate=$(echo "scale=1; $passed_tests * 100 / $total_tests" | bc 2>/dev/null || echo "0")
            echo "Success Rate: ${success_rate}%" >> "$report_file"
        fi
        
        echo "" >> "$report_file"
        
        # Compilation statistics
        echo "Compilation Statistics:" >> "$report_file"
        echo "----------------------" >> "$report_file"
        
        local total_compiles=$(awk -F',' '$2=="compile" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        local successful_compiles=$(awk -F',' '$2=="compile" && $4=="SUCCESS" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        
        echo "Total Compilations: $total_compiles" >> "$report_file"
        echo "Successful: $successful_compiles" >> "$report_file"
        
        if [ $total_compiles -gt 0 ]; then
            local compile_rate=$(echo "scale=1; $successful_compiles * 100 / $total_compiles" | bc 2>/dev/null || echo "0")
            echo "Success Rate: ${compile_rate}%" >> "$report_file"
        fi
        
        echo "" >> "$report_file"
        
        # Performance metrics
        echo "Performance Metrics:" >> "$report_file"
        echo "-------------------" >> "$report_file"
        
        if command -v awk &> /dev/null; then
            local avg_test_time=$(awk -F',' '$2=="test" && $1>="'$date_filter'" {sum+=$3; count++} END {if(count>0) print sum/count; else print 0}' "$ANALYTICS_DIR/metrics.csv")
            local avg_compile_time=$(awk -F',' '$2=="compile" && $1>="'$date_filter'" {sum+=$3; count++} END {if(count>0) print sum/count; else print 0}' "$ANALYTICS_DIR/metrics.csv")
            
            echo "Average Test Time: ${avg_test_time}s" >> "$report_file"
            echo "Average Compile Time: ${avg_compile_time}s" >> "$report_file"
        fi
        
        echo "" >> "$report_file"
        
        # Most recent errors
        echo "Recent Errors:" >> "$report_file"
        echo "-------------" >> "$report_file"
        
        if [ -f "../../logs/errors.log" ]; then
            tail -5 "../../logs/errors.log" >> "$report_file" 2>/dev/null || echo "No recent errors" >> "$report_file"
        else
            echo "No error log found" >> "$report_file"
        fi
        
    else
        echo "No performance data available" >> "$report_file"
    fi
    
    echo "${GREEN}✓ Performance report generated: $report_file${RESET}"
    log_message "INFO" "Performance report generated: $report_file"
    
    # Show summary in console
    echo ""
    echo "${CYAN}${BOLD}Performance Summary:${RESET}"
    if [ -f "$ANALYTICS_DIR/metrics.csv" ]; then
        local total_tests=$(awk -F',' '$2=="test" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        local passed_tests=$(awk -F',' '$2=="test" && $4=="PASS" && $1>="'$date_filter'" {count++} END {print count+0}' "$ANALYTICS_DIR/metrics.csv")
        
        echo "• Tests run: $total_tests"
        echo "• Tests passed: $passed_tests"
        
        if [ $total_tests -gt 0 ]; then
            local success_rate=$(echo "scale=1; $passed_tests * 100 / $total_tests" | bc 2>/dev/null || echo "0")
            echo "• Success rate: ${success_rate}%"
        fi
    fi
}

# Real-time performance dashboard
performance_dashboard() {
    while true; do
        clear
        
        echo "${BLUE}${BOLD}"
        echo "    ██████╗ ███████╗██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ███╗   ██╗ ██████╗███████╗"
        echo "    ██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝██╔════╝"
        echo "    ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██████╔╝██╔████╔██║███████║██╔██╗ ██║██║     █████╗  "
        echo "    ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║██║╚██╗██║██║     ██╔══╝  "
        echo "    ██║     ███████╗██║  ██║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╗███████╗"
        echo "    ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝"
        echo "${RESET}"
        
        local width=80
        
        printf "${CYAN}╭%s╮${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
        printf "${CYAN}│${RESET}${BOLD}${WHITE}%*s${RESET}${CYAN}│${RESET}\n" $(((${#1} + $width - 2)/2)) "REAL-TIME PERFORMANCE DASHBOARD"
        printf "${CYAN}├%s┤${RESET}\n" "$(printf '─%.0s' $(seq 1 $(($width - 2))))"
        
        # System information
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}System Status:${RESET}%$(($width - 17))s ${CYAN}│${RESET}\n" ""
        
        local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}' 2>/dev/null || echo "N/A")
        local memory_usage=$(free | awk 'FNR==2{printf "%.1f%%", $3/($3+$4)*100}' 2>/dev/null || echo "N/A")
        local disk_usage=$(df . | tail -1 | awk '{print $5}' 2>/dev/null || echo "N/A")
        
        printf "${CYAN}│${RESET}   CPU Usage: ${YELLOW}%-10s${RESET} Memory: ${YELLOW}%-10s${RESET} Disk: ${YELLOW}%-10s${RESET}%$(($width - 51))s ${CYAN}│${RESET}\n" "$cpu_usage" "$memory_usage" "$disk_usage" ""
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        
        # Recent activity
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}Recent Activity:${RESET}%$(($width - 19))s ${CYAN}│${RESET}\n" ""
        
        if [ -f "$ANALYTICS_DIR/metrics.csv" ]; then
            local recent_tests=$(tail -5 "$ANALYTICS_DIR/metrics.csv" | awk -F',' '$2=="test" {print "  "$1" - "$3" - "$4}' | tail -3)
            if [ -n "$recent_tests" ]; then
                echo "$recent_tests" | while read -r line; do
                    printf "${CYAN}│${RESET} ${BLUE}%-$(($width - 4))s${RESET} ${CYAN}│${RESET}\n" "$line"
                done
            else
                printf "${CYAN}│${RESET}   ${YELLOW}No recent test activity${RESET}%$(($width - 29))s ${CYAN}│${RESET}\n" ""
            fi
        else
            printf "${CYAN}│${RESET}   ${YELLOW}No performance data available${RESET}%$(($width - 33))s ${CYAN}│${RESET}\n" ""
        fi
        
        printf "${CYAN}│${RESET}%$(($width - 2))s${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET} ${BOLD}${GREEN}Actions:${RESET}%$(($width - 11))s ${CYAN}│${RESET}\n" ""
        printf "${CYAN}│${RESET}   ${BLUE}r${RESET} - Refresh | ${BLUE}g${RESET} - Generate Report | ${BLUE}q${RESET} - Quit%$(($width - 46))s ${CYAN}│${RESET}\n" ""
        
        printf "${CYAN}╰%s╯${RESET}\n" "$(printf '═%.0s' $(seq 1 $(($width - 2))))"
        
        printf "\n${BOLD}${GREEN}Action (auto-refresh in 5s): ${RESET}"
        
        read -t 5 action
        
        case $action in
            r|R)
                continue
                ;;
            g|G)
                echo "Select period: (d)ay, (w)eek, (m)onth"
                read period_choice
                case $period_choice in
                    d|D) generate_performance_report "day" ;;
                    w|W) generate_performance_report "week" ;;
                    m|M) generate_performance_report "month" ;;
                    *) generate_performance_report "week" ;;
                esac
                read -p "Press Enter to continue..."
                ;;
            q|Q)
                return 0
                ;;
        esac
    done
}

# Export functions
export -f init_analytics record_metric monitor_resources generate_performance_report performance_dashboard