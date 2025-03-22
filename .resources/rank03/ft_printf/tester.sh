#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Set paths
STUDENT_DIR="../../../rendu/ft_printf"
STUDENT_FILE="${STUDENT_DIR}/ft_printf.c"
TRACE_DIR="trace"

# Create trace directory
mkdir -p "$TRACE_DIR"
rm -f "$TRACE_DIR"/*

# Verify file exists
if [ ! -f "$STUDENT_FILE" ]; then
    echo -e "${RED}${BOLD}FAILURE - ft_printf.c file not found${RESET}"
    exit 1
fi

# Create test file
cat > test_main.c << 'EOL'
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int ft_printf(const char *format, ...);

int main(void)
{
    int real_ret, your_ret;
    
    // Test 1: %c
    printf("Test 1: Characters\n");
    real_ret = printf("Character: %c\n", 'A');
    your_ret = ft_printf("Character: %c\n", 'A');
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 2: %s
    printf("Test 2: Strings\n");
    real_ret = printf("String: %s\n", "Hello, world!");
    your_ret = ft_printf("String: %s\n", "Hello, world!");
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 3: NULL %s
    printf("Test 3: NULL String\n");
    real_ret = printf("NULL String: %s\n", NULL);
    your_ret = ft_printf("NULL String: %s\n", NULL);
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 4: %d/%i
    printf("Test 4: Integers\n");
    real_ret = printf("Integer: %d, %i\n", 42, -42);
    your_ret = ft_printf("Integer: %d, %i\n", 42, -42);
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 5: %u
    printf("Test 5: Unsigned\n");
    real_ret = printf("Unsigned: %u\n", 4294967295u);
    your_ret = ft_printf("Unsigned: %u\n", 4294967295u);
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 6: %x/%X
    printf("Test 6: Hex\n");
    real_ret = printf("Hex: %x, %X\n", 255, 255);
    your_ret = ft_printf("Hex: %x, %X\n", 255, 255);
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 7: %p
    printf("Test 7: Pointer\n");
    int num = 42;
    real_ret = printf("Pointer: %p\n", (void*)&num);
    your_ret = ft_printf("Pointer: %p\n", (void*)&num);
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 8: NULL %p
    printf("Test 8: NULL Pointer\n");
    real_ret = printf("NULL Pointer: %p\n", NULL);
    your_ret = ft_printf("NULL Pointer: %p\n", NULL);
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    // Test 9: %%
    printf("Test 9: Percent\n");
    real_ret = printf("Percent: %%\n");
    your_ret = ft_printf("Percent: %%\n");
    printf("Real: %d | Yours: %d\n", real_ret, your_ret);
    
    return 0;
}
EOL

# Compile with colorful output
echo -e "${BLUE}${BOLD}Compiling your ft_printf...${RESET}"
gcc -Wall -Wextra -o ft_printf_test test_main.c "$STUDENT_FILE" 2> "${TRACE_DIR}/compile_errors.txt"

# Check compilation and show errors immediately if there are any
if [ $? -ne 0 ]; then
    echo -e "${RED}${BOLD}╔════════════════════════ FAILURE ═════════════════════════╗${RESET}"
    echo -e "${RED}${BOLD}║              Compilation error:                           ║${RESET}"
    echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════════╝${RESET}"
    cat "${TRACE_DIR}/compile_errors.txt"
    exit 1
fi

# Run tests and capture output
echo -e "${CYAN}${BOLD}Running tests...${RESET}"
./ft_printf_test > "${TRACE_DIR}/output.txt" 2>&1

# Check for errors
errors=""
failed_tests=0

# Process output line by line to detect differences
while read -r line; do
    if [[ $line =~ Real:\ ([0-9]+)\ \|\ Yours:\ ([0-9]+) ]]; then
        real="${BASH_REMATCH[1]}"
        yours="${BASH_REMATCH[2]}"
        
        if [ "$real" != "$yours" ]; then
            test_num=$(grep -B 1 "$line" "${TRACE_DIR}/output.txt" | head -1 | grep -o "Test [0-9]:" | cut -d' ' -f2 | tr -d :)
            
            case $test_num in
                1) errors="$errors ${MAGENTA}%c${RESET}";;
                2) errors="$errors ${MAGENTA}%s${RESET}";;
                3) errors="$errors ${MAGENTA}NULL strings${RESET}";;
                4) errors="$errors ${MAGENTA}%d/%i${RESET}";;
                5) errors="$errors ${MAGENTA}%u${RESET}";;
                6) errors="$errors ${MAGENTA}%x/%X${RESET}";;
                7) errors="$errors ${MAGENTA}%p${RESET}";;
                8) errors="$errors ${MAGENTA}NULL pointers${RESET}";;
                9) errors="$errors ${MAGENTA}%%${RESET}";;
            esac
            
            failed_tests=$((failed_tests + 1))
        fi
    fi
done < "${TRACE_DIR}/output.txt"

# Clean up
rm -f test_main.c ft_printf_test

# Show results
if [ $failed_tests -eq 0 ]; then
    echo -e "${GREEN}${BOLD}╔════════════════════════ SUCCESS ═════════════════════════╗${RESET}"
    echo -e "${GREEN}${BOLD}║            All tests passed successfully!                 ║${RESET}"
    echo -e "${GREEN}${BOLD}╚═══════════════════════════════════════════════════════════╝${RESET}"
    exit 0
else
    echo -e "${RED}${BOLD}╔════════════════════════ FAILURE ═════════════════════════╗${RESET}"
    echo -e "${RED}${BOLD}║                Issues with:$errors                ║${RESET}"
    echo -e "${RED}${BOLD}╚═══════════════════════════════════════════════════════════╝${RESET}"
    exit 1
fi