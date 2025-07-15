#!/bin/bash

# Test Optimization Framework for GradeMe-1337
# Reduces compilation overhead and improves performance

source ../../../main/colors.sh
source ../../../main/logging.sh

# Configuration
CACHE_DIR="../../../../trace/cache"
TIMEOUT_COMPILE=30
TIMEOUT_EXECUTION=10
PARALLEL_TESTS=${PARALLEL_TESTS:-0}

# Initialize
mkdir -p "$CACHE_DIR"

# Optimized compilation with caching
compile_with_cache() {
    local source_file="$1"
    local output_file="$2"
    local compile_flags="$3"
    local cache_key=$(echo "$source_file$compile_flags" | md5sum | cut -d' ' -f1)
    local cache_file="$CACHE_DIR/${cache_key}.bin"
    local source_mtime=$(stat -c %Y "$source_file" 2>/dev/null || echo 0)
    local cache_mtime=$(stat -c %Y "$cache_file" 2>/dev/null || echo 0)
    
    # Check if cache is valid
    if [ -f "$cache_file" ] && [ "$cache_mtime" -gt "$source_mtime" ]; then
        log_message "INFO" "Using cached binary for $source_file"
        cp "$cache_file" "$output_file"
        return 0
    fi
    
    # Compile with timeout
    log_message "INFO" "Compiling $source_file with flags: $compile_flags"
    local start_time=$(date +%s)
    
    timeout "$TIMEOUT_COMPILE" gcc $compile_flags -o "$output_file" "$source_file" 2> compile_errors.txt
    local exit_code=$?
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    if [ $exit_code -eq 0 ]; then
        # Cache successful compilation
        cp "$output_file" "$cache_file"
        log_message "INFO" "Compilation successful (${duration}s)"
        track_performance "compile_success" "$duration"
        return 0
    elif [ $exit_code -eq 124 ]; then
        log_message "ERROR" "Compilation timeout after ${TIMEOUT_COMPILE}s"
        track_performance "compile_timeout" "$TIMEOUT_COMPILE"
        return 124
    else
        log_message "ERROR" "Compilation failed (${duration}s)"
        if [ -f compile_errors.txt ]; then
            log_message "ERROR" "Compilation errors: $(cat compile_errors.txt)"
        fi
        track_performance "compile_failure" "$duration"
        return $exit_code
    fi
}

# Run test with proper error handling and timeout
run_test_case() {
    local test_num="$1"
    local expected_binary="$2"
    local student_binary="$3"
    shift 3
    local test_args=("$@")
    
    local start_time=$(date +%s)
    
    # Run both binaries with timeout
    timeout "$TIMEOUT_EXECUTION" ./"$expected_binary" "${test_args[@]}" > expected_output.txt 2>/dev/null
    local expected_exit=$?
    
    timeout "$TIMEOUT_EXECUTION" ./"$student_binary" "${test_args[@]}" > student_output.txt 2>/dev/null
    local student_exit=$?
    
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    
    # Check for timeouts
    if [ $expected_exit -eq 124 ] || [ $student_exit -eq 124 ]; then
        echo "${RED}${BOLD}TIMEOUT Test $test_num${RESET} (>${TIMEOUT_EXECUTION}s)"
        log_message "WARNING" "Test $test_num timed out"
        track_performance "test_timeout" "$TIMEOUT_EXECUTION"
        return 1
    fi
    
    # Compare outputs
    if diff -q expected_output.txt student_output.txt >/dev/null 2>&1; then
        echo "${GREEN}✓ Test $test_num passed${RESET} (${duration}s)"
        log_message "INFO" "Test $test_num passed"
        track_performance "test_pass" "$duration"
        return 0
    else
        echo "${RED}✗ Test $test_num failed${RESET} (${duration}s)"
        echo "${GREEN}Expected:${RESET} \"$(cat expected_output.txt)\""
        echo "${RED}Got:${RESET}      \"$(cat student_output.txt)\""
        log_message "INFO" "Test $test_num failed"
        track_performance "test_fail" "$duration"
        return 1
    fi
}

# Batch test runner with progress tracking
run_test_batch() {
    local exercise_name="$1"
    local expected_binary="$2"
    local student_binary="$3"
    shift 3
    local test_cases=("$@")
    
    local total_tests=${#test_cases[@]}
    local passed_tests=0
    local failed_tests=0
    
    echo "${CYAN}${BOLD}Running $total_tests tests for $exercise_name...${RESET}"
    log_message "INFO" "Starting test batch for $exercise_name ($total_tests tests)"
    
    local overall_start=$(date +%s)
    
    for i in "${!test_cases[@]}"; do
        local test_num=$((i + 1))
        
        if [ "${SHOW_PROGRESS:-1}" = "1" ]; then
            show_progress "$test_num" "$total_tests" "Test $test_num"
        fi
        
        # Parse test case (format: "arg1|arg2|arg3")
        IFS='|' read -ra args <<< "${test_cases[$i]}"
        
        if run_test_case "$test_num" "$expected_binary" "$student_binary" "${args[@]}"; then
            passed_tests=$((passed_tests + 1))
        else
            failed_tests=$((failed_tests + 1))
        fi
        
        # Clean up test outputs
        rm -f expected_output.txt student_output.txt
    done
    
    local overall_end=$(date +%s)
    local total_duration=$((overall_end - overall_start))
    
    # Final results
    echo ""
    if [ $failed_tests -eq 0 ]; then
        echo "${GREEN}${BOLD}✓ ALL TESTS PASSED!${RESET} ($passed_tests/$total_tests in ${total_duration}s)"
        log_test_result "$exercise_name" "all" "PASS" "$total_duration"
        return 0
    else
        echo "${RED}${BOLD}✗ SOME TESTS FAILED${RESET} ($passed_tests/$total_tests passed in ${total_duration}s)"
        log_test_result "$exercise_name" "all" "FAIL" "$total_duration"
        return 1
    fi
}

# Enhanced error reporting
generate_error_report() {
    local exercise_name="$1"
    local error_type="$2"
    local details="$3"
    
    local report_file="../../../../trace/error_report_${exercise_name}_$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$report_file" << EOF
GradeMe-1337 Error Report
========================
Exercise: $exercise_name
Error Type: $error_type
Timestamp: $(date +'%Y-%m-%d %H:%M:%S')
User: $(whoami)
Working Directory: $(pwd)

Details:
$details

System Information:
$(uname -a)

Recent Compilation Errors:
$(cat compile_errors.txt 2>/dev/null || echo "No compilation errors recorded")

Environment Variables:
PATH=$PATH
CC=${CC:-gcc}
CFLAGS=${CFLAGS:-none}

EOF
    
    echo "${YELLOW}Error report generated: $report_file${RESET}"
    log_message "ERROR" "Error report generated for $exercise_name: $report_file"
}

# Cleanup function
cleanup_test_files() {
    rm -f expected_output.txt student_output.txt compile_errors.txt
    rm -f out1 out2 out1.txt out2.txt
    
    # Clean old cache files (older than 1 day)
    find "$CACHE_DIR" -name "*.bin" -mtime +1 -delete 2>/dev/null
}

# Export functions for use in specific test scripts
export -f compile_with_cache run_test_case run_test_batch generate_error_report cleanup_test_files