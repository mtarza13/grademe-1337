#!/bin/bash

# Label script for GradeMe-1337 tool
# This script handles initialization and setup tasks

source colors.sh

# Clear the screen for a clean start
clear

# Create necessary directories
mkdir -p ../../rendu
mkdir -p ../../logs
mkdir -p ../../trace

# Set proper permissions for all test scripts
find ../rank02 -name "tester.sh" -exec chmod +x {} \;
find ../rank03 -name "tester.sh" -exec chmod +x {} \;

# Initialize log file with timestamp
echo "$(date +'%Y-%m-%d %H:%M:%S') - GradeMe-1337 initialized" > ../../logs/session.log

# Success indicator
echo "${GREEN}${BOLD}System initialized successfully${RESET}" >&2