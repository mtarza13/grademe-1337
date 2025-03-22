#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include "ft_printf.h"

int main(void)
{
    int real_ret, your_ret;
    
    // Test 1: Basic character
    printf("\n\033[1;34mTest 1: Characters\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Character: %c\n", 'A');
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Character: %c\n", 'A');
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 2: Basic string
    printf("\n\033[1;34mTest 2: Strings\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("String: %s\n", "Hello, world!");
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("String: %s\n", "Hello, world!");
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 3: Empty string instead of NULL to avoid compiler warnings
    printf("\n\033[1;34mTest 3: Empty String\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Empty String: %s\n", "");
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Empty String: %s\n", "");
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 4: Basic integer
    printf("\n\033[1;34mTest 4: Integers\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Integer: %d\n", 42);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Integer: %d\n", 42);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 5: Negative integer
    printf("\n\033[1;34mTest 5: Negative Integers\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Negative: %d\n", -42);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Negative: %d\n", -42);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 6: Zero integer
    printf("\n\033[1;34mTest 6: Zero Integer\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Zero: %d\n", 0);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Zero: %d\n", 0);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 7: INT_MAX
    printf("\n\033[1;34mTest 7: INT_MAX\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("INT_MAX: %d\n", INT_MAX);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("INT_MAX: %d\n", INT_MAX);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 8: INT_MIN
    printf("\n\033[1;34mTest 8: INT_MIN\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("INT_MIN: %d\n", INT_MIN);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("INT_MIN: %d\n", INT_MIN);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);

    // Test 9: Unsigned integers
    printf("\n\033[1;34mTest 9: Unsigned Integers\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Unsigned: %u\n", 4294967295u);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Unsigned: %u\n", 4294967295u);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 10: Hexadecimal lowercase
    printf("\n\033[1;34mTest 10: Hexadecimal (lowercase)\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Hex (lowercase): %x\n", 255);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Hex (lowercase): %x\n", 255);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 11: Hexadecimal uppercase
    printf("\n\033[1;34mTest 11: Hexadecimal (uppercase)\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Hex (uppercase): %X\n", 255);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Hex (uppercase): %X\n", 255);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 12: Pointer
    printf("\n\033[1;34mTest 12: Pointers\033[0m\n");
    int num = 42;
    int *ptr = &num;
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Pointer: %p\n", (void *)ptr);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Pointer: %p\n", (void *)ptr);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 13: NULL pointer
    printf("\n\033[1;34mTest 13: NULL Pointer\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("NULL Pointer: %p\n", (void*)NULL);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("NULL Pointer: %p\n", (void*)NULL);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 14: Percent sign
    printf("\n\033[1;34mTest 14: Percent Sign\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Percent: %%\n");
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Percent: %%\n");
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    // Test 15: Mixed formats
    printf("\n\033[1;34mTest 15: Mixed Formats\033[0m\n");
    
    printf("\033[32mReal printf:\033[0m ");
    real_ret = printf("Mixed: %c %s %d %i %u %x %X %p %%\n", 'A', "Hello", 42, -42, 42, 42, 42, (void *)ptr);
    printf("\033[32mReturn value: %d\033[0m\n", real_ret);
    
    printf("\033[36mYour ft_printf:\033[0m ");
    your_ret = ft_printf("Mixed: %c %s %d %i %u %x %X %p %%\n", 'A', "Hello", 42, -42, 42, 42, 42, (void *)ptr);
    printf("\033[36mReturn value: %d\033[0m\n", your_ret);
    
    printf("\n\033[1;33mTests completed.\033[0m\n");
    
    return 0;
}