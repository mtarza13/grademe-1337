#!/bin/bash
source ../../../main/colors.sh
clear

echo "${YELLOW}${BOLD}FT_PRINTF TESTER${RESET}"
echo "${YELLOW}═════════════════${RESET}"
echo ""

# Source code
FT_PRINTF_C="ft_printf.c"
FT_PRINTF_H="ft_printf.h"
MAIN_TEST_C="main_test.c"

# Output directories
mkdir -p output

# Create test main if it doesn't exist
if [ ! -f "$MAIN_TEST_C" ]; then
    cat > "$MAIN_TEST_C" << 'EOL'
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "ft_printf.h"

int main(void)
{
    int real_ret, your_ret;
    
    // Test 1: Basic character
    printf("\n${BOLD}${BLUE}Test 1: Characters${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Character: %c\n", 'A');
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Character: %c\n", 'A');
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 2: Basic string
    printf("\n${BOLD}${BLUE}Test 2: Strings${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("String: %s\n", "Hello, world!");
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("String: %s\n", "Hello, world!");
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 3: NULL string
    printf("\n${BOLD}${BLUE}Test 3: NULL String${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("NULL String: %s\n", NULL);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("NULL String: %s\n", NULL);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 4: Basic integer
    printf("\n${BOLD}${BLUE}Test 4: Integers${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Integer: %d\n", 42);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Integer: %d\n", 42);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 5: Negative integer
    printf("\n${BOLD}${BLUE}Test 5: Negative Integers${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Negative: %d\n", -42);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Negative: %d\n", -42);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 6: Zero integer
    printf("\n${BOLD}${BLUE}Test 6: Zero Integer${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Zero: %d\n", 0);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Zero: %d\n", 0);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 7: INT_MAX
    printf("\n${BOLD}${BLUE}Test 7: INT_MAX${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("INT_MAX: %d\n", INT_MAX);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("INT_MAX: %d\n", INT_MAX);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 8: INT_MIN
    printf("\n${BOLD}${BLUE}Test 8: INT_MIN${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("INT_MIN: %d\n", INT_MIN);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("INT_MIN: %d\n", INT_MIN);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);

    // Test 9: Unsigned integers
    printf("\n${BOLD}${BLUE}Test 9: Unsigned Integers${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Unsigned: %u\n", 4294967295u);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Unsigned: %u\n", 4294967295u);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 10: Hexadecimal lowercase
    printf("\n${BOLD}${BLUE}Test 10: Hexadecimal (lowercase)${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Hex (lowercase): %x\n", 255);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Hex (lowercase): %x\n", 255);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 11: Hexadecimal uppercase
    printf("\n${BOLD}${BLUE}Test 11: Hexadecimal (uppercase)${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Hex (uppercase): %X\n", 255);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Hex (uppercase): %X\n", 255);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 12: Pointer
    printf("\n${BOLD}${BLUE}Test 12: Pointers${RESET}\n");
    int num = 42;
    int *ptr = &num;
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Pointer: %p\n", (void *)ptr);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Pointer: %p\n", (void *)ptr);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 13: NULL pointer
    printf("\n${BOLD}${BLUE}Test 13: NULL Pointer${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("NULL Pointer: %p\n", NULL);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("NULL Pointer: %p\n", NULL);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 14: Percent sign
    printf("\n${BOLD}${BLUE}Test 14: Percent Sign${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Percent: %%\n");
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Percent: %%\n");
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    // Test 15: Mixed formats
    printf("\n${BOLD}${BLUE}Test 15: Mixed Formats${RESET}\n");
    
    printf("${GREEN}Real printf:${RESET} ");
    real_ret = printf("Mixed: %c %s %d %i %u %x %X %p %%\n", 'A', "Hello", 42, -42, 42, 42, 42, (void *)ptr);
    printf("${GREEN}Return value: %d${RESET}\n", real_ret);
    
    printf("${CYAN}Your ft_printf:${RESET} ");
    your_ret = ft_printf("Mixed: %c %s %d %i %u %x %X %p %%\n", 'A', "Hello", 42, -42, 42, 42, 42, (void *)ptr);
    printf("${CYAN}Return value: %d${RESET}\n", your_ret);
    
    printf("\n${BOLD}${YELLOW}Tests completed.${RESET}\n");
    
    return 0;
}
EOL
fi

# Compile the tester
echo "${BLUE}${BOLD}Compiling the tester...${RESET}"
gcc -Wall -Wextra -o ft_printf_test "$FT_PRINTF_C" "$MAIN_TEST_C" -I.

# Check if compilation succeeded
if [ $? -ne 0 ]; then
    echo "${RED}${BOLD}Compilation failed!${RESET}"
    exit 1
fi

# Run the tests
echo "${GREEN}${BOLD}Running tests...${RESET}"
echo "-----------------------"
./ft_printf_test

# Cleanup
echo "${YELLOW}${BOLD}Cleaning up...${RESET}"
rm -f ft_printf_test

echo ""
echo "${GREEN}${BOLD}✓ Tester completed successfully!${RESET}"
echo "${YELLOW}${BOLD}Check the output above to compare your ft_printf with the real printf.${RESET}"
echo "${YELLOW}${BOLD}Make sure your return values match and the output formatting is identical.${RESET}"