#!/bin/bash
source ../../../main/colors.sh

# Performance optimization: Compile once, test multiple times
file1=first_word.c
file2=../../../../rendu/first_word/first_word.c

# Logging
echo "$(date +'%Y-%m-%d %H:%M:%S') - Starting first_word tests" >> ../../../../logs/session.log

# Progress indicator
echo "${CYAN}${BOLD}Running first_word tests...${RESET}"

# Check if student file exists
if [ ! -f "$file2" ]; then
    echo "${RED}${BOLD}ERROR: $file2 not found${RESET}"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - ERROR: Student file not found" >> ../../../../logs/session.log
    exit 1
fi

# Compile once with full warnings
echo "${YELLOW}Compiling with strict warnings...${RESET}"
gcc -Werror -Wall -Wextra -o out1 "$file1" 2>/dev/null
gcc -Werror -Wall -Wextra -o out2 "$file2" 2>/dev/null

# Check compilation
if [ ! -f out1 ] || [ ! -f out2 ]; then
    echo "${RED}${BOLD}COMPILATION FAILED${RESET}"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - COMPILATION FAILED" >> ../../../../logs/session.log
    # Fallback: try with less strict warnings
    echo "${YELLOW}Retrying with relaxed warnings...${RESET}"
    gcc -w -o out1 "$file1" 2>/dev/null
    gcc -w -o out2 "$file2" 2>/dev/null
    
    if [ ! -f out1 ] || [ ! -f out2 ]; then
        echo "${RED}${BOLD}CRITICAL: Cannot compile files${RESET}"
        exit 1
    fi
fi

# Test cases array for better organization
declare -a test_cases=(
    "L'eSPrit nE peUt plUs pRogResSer s'Il staGne et sI peRsIsTent VAnIte et auto-justification."
    "S'enTOuRer dE sECreT eSt uN sIGnE De mAnQuE De coNNaiSSanCe.  "
    "3:21 Ba  tOut  moUn ki Ka di KE m'en Ka fe fot"
    "Papache est un sabre|a|o"
    "zaz|art|zul"
    "zaz|r|u"
    "jacob|a|b|c|e"
    "ZoZ eT Dovid oiME le METol.|o|a"
    "wNcOre Un ExEmPle Pas Facilw a Ecrirw |w|e"
    "AkjhZ zLKIJz , 23y "
    "FOR PONY"
    "this        ...       is sparta, then again, maybe    not"
    "   "
    "a|b"
    "  lorem,ipsum  "
    ""
    ""  # Empty args test
)

test_count=0
failed_count=0

# Run tests efficiently
for i in "${!test_cases[@]}"; do
    test_count=$((test_count + 1))
    case_args="${test_cases[$i]}"
    
    # Handle special cases with multiple arguments
    if [[ "$case_args" == *"|"* ]]; then
        IFS='|' read -ra ARGS <<< "$case_args"
        ./out1 "${ARGS[@]}" > out1.txt 2>/dev/null
        ./out2 "${ARGS[@]}" > out2.txt 2>/dev/null
    else
        ./out1 "$case_args" > out1.txt 2>/dev/null
        ./out2 "$case_args" > out2.txt 2>/dev/null
    fi
    
    if ! diff -q out1.txt out2.txt >/dev/null; then
        failed_count=$((failed_count + 1))
        out1_content=$(cat out1.txt)
        out2_content=$(cat out2.txt)
        echo "${RED}${BOLD}FAIL Test $test_count${RESET}"
        echo "${GREEN}Expected:${RESET} \"$out1_content\""
        echo "${RED}Your:${RESET}     \"$out2_content\""
        echo "$(date +'%Y-%m-%d %H:%M:%S') - FAIL Test $test_count" >> ../../../../logs/session.log
    else
        echo "${GREEN}✓ Test $test_count passed${RESET}"
    fi
done

# Cleanup
rm -f out1 out2 out1.txt out2.txt 2>/dev/null

# Results
if [ $failed_count -eq 0 ]; then
    echo "${GREEN}${BOLD}SUCCESS: All $test_count tests passed!${RESET}"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - SUCCESS: All tests passed" >> ../../../../logs/session.log
    exit 0
else
    echo "${RED}${BOLD}FAILED: $failed_count/$test_count tests failed${RESET}"
    echo "$(date +'%Y-%m-%d %H:%M:%S') - FAILED: $failed_count/$test_count tests" >> ../../../../logs/session.log
    exit 1
fi