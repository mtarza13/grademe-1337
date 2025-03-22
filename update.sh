source .resources/main/colors.sh
clear

echo "${GREEN}${BOLD}CLEANING...${RESET}"
echo ""
sleep 1
rm -rf rendu
rm -rf .resources
rm README.md
rm tr.md
echo ""

git clone https://github.com/Tboooot/42ExamPractice
echo "${GREEN}${BOLD}UPDATING...${RESET}"
echo ""
sleep 1
echo "${GREEN}${BOLD}Please wait...${RESET}"
sleep 1
cd 42ExamPractice
mv README.md ..
mv tr.md ..
mv .resources ..
cd ..
echo "${GREEN}${BOLD}DONE!${RESET}"
sleep 0.5
exit
