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
