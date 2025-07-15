#!/bin/bash

# Optimized fizzbuzz tester using the new test framework
source ../../../main/test_framework.sh

EXERCISE_NAME="fizzbuzz"
REFERENCE_FILE="fizzbuzz.c"
STUDENT_FILE="../../../../rendu/fizzbuzz/fizzbuzz.c"

# Main test execution
main() {
    echo "${CYAN}${BOLD}Testing $EXERCISE_NAME...${RESET}"
    log_message "INFO" "Starting $EXERCISE_NAME tests"
    
    # Check if student file exists
    if [ ! -f "$STUDENT_FILE" ]; then
        echo "${RED}${BOLD}ERROR: Student file not found: $STUDENT_FILE${RESET}"
        generate_error_report "$EXERCISE_NAME" "missing_file" "Student file $STUDENT_FILE not found"
        exit 1
    fi
    
    # Compile both versions with caching
    if ! compile_with_cache "$REFERENCE_FILE" "reference_binary" "-Werror -Wall -Wextra"; then
        echo "${RED}${BOLD}CRITICAL: Reference compilation failed${RESET}"
        generate_error_report "$EXERCISE_NAME" "reference_compile" "Reference file compilation failed"
        exit 1
    fi
    
    if ! compile_with_cache "$STUDENT_FILE" "student_binary" "-Werror -Wall -Wextra"; then
        echo "${YELLOW}${BOLD}Warning: Strict compilation failed, trying with relaxed flags...${RESET}"
        if ! compile_with_cache "$STUDENT_FILE" "student_binary" "-w"; then
            echo "${RED}${BOLD}ERROR: Student compilation failed${RESET}"
            generate_error_report "$EXERCISE_NAME" "student_compile" "Student file compilation failed with both strict and relaxed flags"
            cleanup_test_files
            exit 1
        fi
    fi
    
    # FizzBuzz typically has no arguments, just tests the output
    local test_cases=("")  # Single test case with no arguments
    
    if run_test_batch "$EXERCISE_NAME" "reference_binary" "student_binary" "${test_cases[@]}"; then
        echo "${GREEN}${BOLD}🎉 $EXERCISE_NAME tests completed successfully!${RESET}"
        cleanup_test_files
        exit 0
    else
        echo "${RED}${BOLD}❌ $EXERCISE_NAME tests failed${RESET}"
        generate_error_report "$EXERCISE_NAME" "test_failure" "One or more test cases failed"
        cleanup_test_files
        exit 1
    fi
}

# Trap to ensure cleanup on exit
trap cleanup_test_files EXIT

# Run main function
main "$@"