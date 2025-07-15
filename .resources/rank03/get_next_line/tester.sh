#!/bin/bash


STUDENT_DIR="../../../rendu/get_next_line"
TRACE_DIR="trace"

mkdir -p "../../../$TRACE_DIR"
rm -f "$TRACE_DIR"/*


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'


mandatory_files=("get_next_line.c" "get_next_line.h")
missing_files=0

for file in "${mandatory_files[@]}"; do
    if [ ! -f "$STUDENT_DIR/$file" ]; then
        echo -e "${RED}${BOLD}FAILURE - $file not found${RESET}"
        missing_files=$((missing_files + 1))
    fi
done

if [ $missing_files -gt 0 ]; then
    exit 1
fi

if [ ! -f "empty_file.txt" ]; then
    touch empty_file.txt
fi

if [ ! -f "empty_lines.txt" ]; then
    printf "\n\n\n" > empty_lines.txt
fi

if [ ! -f "single_line.txt" ]; then
    echo "This is a single line file." > single_line.txt
fi

if [ ! -f "no_newline_eof.txt" ]; then
    printf "This file has no newline at the end" > no_newline_eof.txt
fi

if [ ! -f "long_line.txt" ]; then
    yes "A" | head -c 10000 > long_line.txt
    echo "" >> long_line.txt
fi

if [ ! -f "mixed_lines.txt" ]; then
    cat > mixed_lines.txt << EOF
This is line 1
This is line 2

This is line 4 after an empty line
This is the last line
EOF
fi

if [ ! -f "test_file.txt" ]; then
    cat > test_file.txt << EOF
Hello, World!
This is a test file for get_next_line.

It has multiple lines.
Some are short.
Some are a bit longer than the others.

And some lines are empty, like the one above.
The last line has no newline.
EOF
fi

if [ ! -f "binary_file.bin" ]; then
    head -c 1024 /dev/urandom > binary_file.bin
fi

cat > test_main.c << 'EOL'
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include "get_next_line.h"

void test_file(const char *filename, int test_num) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        printf("Error opening file: %s\n", filename);
        return;
    }
    
    printf("\n--- Test %d: %s ---\n", test_num, filename);
    
    char *line;
    int line_count = 0;
    
    while ((line = get_next_line(fd)) != NULL) {
        line_count++;
        printf("Line %d (%lu): %s", line_count, strlen(line), line);
        if (line[strlen(line) - 1] != '\n')
            printf("\n");
        free(line);
    }
    
    if (line_count == 0) {
        printf("No lines read from file\n");
    } else {
        printf("Total lines read: %d\n", line_count);
    }
    
    close(fd);
}

void test_fd_error() {
    printf("\n--- Test: Invalid file descriptor ---\n");
    char *line = get_next_line(-1);
    if (line == NULL) {
        printf("Correctly returned NULL for invalid FD\n");
    } else {
        printf("ERROR: Did not return NULL for invalid FD\n");
        free(line);
    }
}

int main(void) {
    test_file("empty_file.txt", 1);
    test_file("empty_lines.txt", 2);
    test_file("single_line.txt", 3);
    test_file("no_newline_eof.txt", 4);
    test_file("mixed_lines.txt", 5);
    test_file("test_file.txt", 6);
    test_file("long_line.txt", 7);
    test_fd_error();
    
    printf("\nAll tests completed.\n");
    return 0;
}
EOL

compile_and_test() {
    local buffer_size=$1
    
    echo -e "${BLUE}${BOLD}Testing with BUFFER_SIZE=$buffer_size${RESET}"
    
    gcc -Wall -Wextra -Werror -D BUFFER_SIZE=$buffer_size test_main.c "$STUDENT_DIR/get_next_line.c" -o gnl_test 2> "${TRACE_DIR}/compile_errors_buffer_${buffer_size}.txt"
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}${BOLD}FAILURE - Compilation error with BUFFER_SIZE=$buffer_size${RESET}"
        cat "${TRACE_DIR}/compile_errors_buffer_${buffer_size}.txt"
        return 1
    fi
    
    ./gnl_test > "${TRACE_DIR}/output_buffer_${buffer_size}.txt" 2>&1
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}${BOLD}FAILURE - Runtime error with BUFFER_SIZE=$buffer_size${RESET}"
        return 1
    fi
    
    echo -e "${GREEN}${BOLD}Test with BUFFER_SIZE=$buffer_size completed successfully${RESET}"
    rm -f gnl_test
    return 0
}

echo -e "${YELLOW}${BOLD}Running get_next_line tests...${RESET}"

failed=0

compile_and_test 1
if [ $? -ne 0 ]; then
    failed=$((failed + 1))
fi

compile_and_test 42
if [ $? -ne 0 ]; then
    failed=$((failed + 1))
fi

compile_and_test 10000000
if [ $? -ne 0 ]; then
    failed=$((failed + 1))
fi

rm -f test_main.c

if [ $failed -eq 0 ]; then
    echo -e "${GREEN}${BOLD}SUCCESS - All tests passed${RESET}"
    exit 0
else
    echo -e "${RED}${BOLD}FAILURE - $failed test(s) failed${RESET}"
    exit 1
fi